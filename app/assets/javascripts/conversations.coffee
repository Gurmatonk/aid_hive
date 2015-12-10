# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'ready page:load', ->
  if $('body').is('body.conversations')
    msgs_container = $('.messages')[0]
    $('.messages').scrollTop(msgs_container.scrollHeight)

    conversation_div = $('#selected-conversation')
    if conversation_div.length == 1
      setInterval ->
        conversation_url = window.location.pathname + '/' + conversation_div.first().data('conversation-id') + '?' + 'last_receipt_id=' + conversation_div.first().data('last-receipt-id')
        $.getScript conversation_url
      , 2000
