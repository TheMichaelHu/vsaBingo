class MessagesController < WebsocketRails::BaseController
  def initialize_session
    controller_store = {}
  end

  def message_receive
    receive_message = message()
    broadcast_message(:bingo_message, receive_message)
  end

  def handle_room_message
    msg = message()
    room = msg["room"].to_s
    player = msg["player"]
    if msg["type"] == "join"
      controller_store[room] ||= {}
      controller_store[room][:players] ||= {}
      if !controller_store[room][:started]
        controller_store[room][:players][player] = {}
      end
      send_room_update room

    elsif msg["type"] == "leave" and !controller_store[room][:starting]
      controller_store[room][:players].delete player
      send_room_update room

    elsif msg["type"] == "start"
      if !controller_store[room][:starting]
        controller_store[room][:num_players] = controller_store[room][:players].length
        controller_store[room][:starting] = true
        controller_store[room][:started] = false
      end
      send_message room, "start"
    end
  end

  def send_room_update(room)
    broadcast_message room, {type: "update", count: controller_store[room][:players].length, players: controller_store[room][:players]}
  end

  def handle_bingo_message
    msg = message()
    room = msg["room"].to_s
    player = msg["player"]
    players = controller_store[room][:players]



    if msg["type"] == "join" and !controller_store[room][:started]
      if players.keys.include? player
        players[player][:joined] = true
      end
      players_joined = 0
      players.each do |player, value|
        players_joined += 1 if value[:joined]
      end
      if players_joined >= controller_store[room][:num_players]
        controller_store[room][:started] = true
        handle_start(room)
      end

    elsif msg["type"] == "leave"
      players = players.keys
      next_turn(room) if controller_store[room][:started] and controller_store[room][:turn][:id] == player
      unless controller_store[room][:players].delete(player).nil?
        players = controller_store[room][:players].keys
        players.length.times do |n|
          controller_store[room][:players][players[n]][:next] = {id: players[n - 1], name: Player.find(players[n - 1]).name}
        end
      end
      send_bingo_update(room)

      delete_room(room) if controller_store[room][:started] and players.length == 0

    elsif msg["type"] == "number" and player == controller_store[room][:turn][:id]
      handle_number(room, msg["message"].to_i)
      victor = get_victor(room, 5)
      if victor.nil?
        send_bingo_update room
      else
        controller_store[room][:victor] = victor
        broadcast_message room, {type: "game_over", turn: nil, players: controller_store[room][:players], victor: {id: victor, name: controller_store[room][:players][victor][:name]}}
      end

    elsif msg["type"] == "victory_msg" and player == controller_store[room][:victor]
      victor = controller_store[room][:victor]
      broadcast_message room, {type: "victory_msg", message: msg["message"], victor: {id: victor, name: controller_store[room][:players][victor][:name]}}
      delete_room(room)
    end
  end

  def send_bingo_update(room)
    broadcast_message room, {type: "update", turn: controller_store[room][:turn], players: controller_store[room][:players], numbers: controller_store[room][:numbers].last(5), names: controller_store[room][:numbers_names].last(5)}
  end

  def send_message(room, type, message="")
    broadcast_message room.to_s, {type: type, message: message}
  end

  def handle_start(room)
    controller_store[room][:starting] = false
    players = controller_store[room][:players].keys
    boards = generate_boards(players.length, (10..60).to_a, 25, 0.8)
    controller_store[room][:numbers] = []
    controller_store[room][:numbers_names] = []
    (players.length).times do |n|
      controller_store[room][:players][players[n]][:name] = Player.find(players[n]).name # should refactor into one query
      controller_store[room][:players][players[n]][:board] = boards[n]
      controller_store[room][:players][players[n]][:next] = {id: players[n - 1], name: Player.find(players[n - 1]).name}
    end
    controller_store[room][:turn] = { id: players.first, name: Player.find(players.first).name }
    send_bingo_update room
  end

  def handle_number(room, number)
    if !controller_store[room][:numbers].include? number
      players = controller_store[room][:players]
      players.keys.each do |player|
        board = players[player][:board]
        num_rows = board.length
        num_rows.times do |row|
          num_rows.times do |col|
            if board[row][col][:number] == number
              controller_store[room][:players][player][:board][row][col][:called] = true
              next
            end
          end
        end
      end
      controller_store[room][:numbers].push number
      controller_store[room][:numbers_names].push controller_store[room][:turn][:name]
      next_turn(room)
    end
  end

  def next_turn(room)
    controller_store[room][:turn] = controller_store[room][:players][controller_store[room][:turn][:id]][:next]
  end

  def generate_boards(num_boards, numbers, board_size, similarity)
    numbers.shuffle!
    init_board_numbers = numbers.take board_size
    unused_numbers = numbers.drop board_size
    boards = []
    num_rows = Math.sqrt(board_size).to_i

    num_boards.times do
      board_nums = init_board_numbers.shuffle.take((board_size * similarity).to_i)
      board_nums.concat unused_numbers.shuffle.take(board_size - board_nums.length)
      board = []
      num_rows.times do |row|
        board.push []
        num_rows.times do |col|
          board[row].push({number: board_nums[col * num_rows + row], called: false})
        end
      end
      boards.push board
    end

    return boards
  end

  def get_victor(room, points)
    controller_store[room][:players].each do |key, value|
      if board_points(value[:board]) >= points
        return key
      end
    end
    return nil
  end

  def board_points(board)
    num_rows = board.length
    points = 0
    diag_bingo = true
    diag_bingo_2 = true
    num_rows.times do |n|
      row_bingo = true
      col_bingo = true
      diag_bingo = diag_bingo && board[n][n][:called]
      diag_bingo_2 = diag_bingo_2 && board[n][num_rows-n-1][:called]
      num_rows.times do |m|
        row_bingo = row_bingo && board[n][m][:called]
        col_bingo = col_bingo && board[m][n][:called]
      end
      points += 1 if row_bingo
      points += 1 if col_bingo
    end
    points += 1 if diag_bingo
    points += 1 if diag_bingo_2
    return points
  end

  def delete_room(room)
    controller_store.delete room
    controller_store[room][:players] = {}
    controller_store[room][:started] = false
  end
end
