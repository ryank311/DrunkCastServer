# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# {addPlayer : {number: 1, name: "Some Name", color: 0xFFFFFF}}

window.onload = ->
  cast.receiver.logger.setLevelValue(0)
  window.castReceiverManager = cast.receiver.CastReceiverManager.getInstance()
  console.log 'Starting Receiver Manager' 
  
  # handler for the 'ready' event
  castReceiverManager.onReady = (event) ->
    console.log('Received Ready event: ' + JSON.stringify(event.data))
    window.castReceiverManager.setApplicationState("Application status is ready...")
  
  # handler for 'senderconnected' event
  castReceiverManager.onSenderConnected = (event) ->
    console.log('Received Sender Connected event: ' + event.data)
    console.log(window.castReceiverManager.getSender(event.data).userAgent)
  
  # handler for 'senderdisconnected' event
  castReceiverManager.onSenderDisconnected = (event) ->
    console.log('Received Sender Disconnected event: ' + event.data)
    if window.castReceiverManager.getSenders().length == 0
      window.close()
    
  
  # handler for 'systemvolumechanged' event
  castReceiverManager.onSystemVolumeChanged = (event) ->
    console.log('Received System Volume Changed event: ' + event.data['level'] + ' ' + event.data['muted'])

  # create a CastMessageBus to handle messages for a custom namespace
  window.messageBus = window.castReceiverManager.getCastMessageBus('urn:x-cast:com.king.drunk')

  # handler for the CastMessageBus message event
  window.messageBus.onMessage = (event) ->
    console.log('Message [' + event.senderId + ']: ' + event.data)
    # display the message from the sender
    handleEvent(event.data)
    # inform all senders on the CastMessageBus of the incoming message event
    # sender message listener will be invoked
    window.messageBus.send(event.senderId, event.data)
  

  # initialize the CastReceiverManager with an application status message
  window.castReceiverManager.start({statusText: "Application is starting"})
  console.log 'Receiver Manager started'


# utility function to display the text message in the input field
handleEvent = (text) ->
  toast text
  if text? and text.addPlayer?
    addPlayerEvent text.addPlayer
  window.castReceiverManager.setApplicationState text

addPlayerEvent = (player) ->
  if player.number? 
    playerName = '#player #{player.number}'
    $(playerName).css 'background-color', player.color
    $('#{playerName} .Name').text player.name
    $(playerName).show();

#parseEventType = (text) ->

toast = (message) ->
  $('#console_message').text message
  $('.Console').show()
  setTimeout ( ->
      $('.Console').hide()
  ), 5000
