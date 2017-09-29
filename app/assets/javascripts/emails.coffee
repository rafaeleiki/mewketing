initForEmails = ->
  $('#email_template').change ->
    body = $ '#email_body'
    templateBody = $(this).val()

    $('#empty_template').toggle(templateBody == '')
    if (templateBody != '')
      templateBody += '\n\n'

    body.text templateBody + body.text()


$(document).on 'turbolinks:load', -> initForEmails()