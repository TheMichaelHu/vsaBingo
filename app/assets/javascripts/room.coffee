# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
dispatcher.bind "join", (message) ->
  console.log("Hello #{message["name"]}")

dispatcher.bind "leave", (message) ->
  console.log("Okay bye #{message["name"]}")

dispatcher.bind "start", (message) ->
  console.log("START")

document.getElementById("start").onclick = ->
  dispatcher.trigger("bingo_message", "start");
