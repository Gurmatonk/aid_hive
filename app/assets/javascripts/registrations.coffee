$(document).ready ->

  update_password_strength = (e) ->
    pass = $('input[name="user[password]"]').val()
    pass_confirmation = $('input[name="user[password_confirmation]"]').val()
    result = zxcvbn(pass)
    info = $('div[name="password_strength"]')
    info.html ''
    if pass == pass_confirmation && (result.score >= 4 && pass.length >= 8 && pass.length <= 72)
      info.removeClass('alert-danger')
      info.addClass('alert-success')
      info.text info.data('success_hint')
    else
      info.removeClass 'alert-success'
      info.addClass 'alert-danger'
      # TODO: this should probably become an own class
      msg = '<ul style="margin-left: -6%">'
      msg += '<li>' + info.data('strength_hint') + '</li>' if result.score < 4
      if pass != pass_confirmation
        msg += '<li>' + info.data('mismatch_hint') + '</li>'
      info.html(msg)

  $('input[name="user[password]"]').on 'keyup change blur', update_password_strength
  $('input[name="user[password_confirmation]"]').on 'keyup change blur', update_password_strength
