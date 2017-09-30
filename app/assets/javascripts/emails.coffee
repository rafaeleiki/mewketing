initForEmails = ->
  $('#email_template').change ->
    body = $ '#email_body'
    templateBody = $(this).val()

    $('#empty_template').toggle(templateBody == '')
    if (templateBody != '')
      templateBody += '\n\n'

    body.val(templateBody + body.val())


$(document).on 'turbolinks:load', -> initForEmails()