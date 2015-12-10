$(document).ready ->
  $('#send_entry_message_form').submit ->
    text_area = $('textarea#message_body')
    text_area.val(text_area.data('relates-to-hint') + '\n' + $('textarea#message_body').val())

  $('#send_message').on 'shown.bs.modal', ->
    $('textarea#message_body').focus()
