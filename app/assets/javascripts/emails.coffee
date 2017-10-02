initForEmails = ->
  $('.datetime_select').wrap('<div class="mdl-selectfield mdl-js-selectfield"> </div>')
  $('.datetime_select').after('<div class="mdl-selectfield__icon"><i class="material-icons">arrow_drop_down</i></div>')
  $('.year').parent().addClass('year');
  $('.month').parent().addClass('month');
  $('.day').parent().addClass('day');
  $('.hour').parent().addClass('hour');
  $('.minute').parent().addClass('minute');
  $('.second').parent().addClass('second');

  $('#email_template').change ->
    body = $ '#email_body'
    templateBody = $(this).val()

    $('#empty_template').toggle(templateBody == '')
    if (templateBody != '')
      templateBody += '\n\n'

    body.val(templateBody + body.val())
    event = new Event 'input', { bubbles: true }
    body[0].dispatchEvent event


$(document).on 'turbolinks:load', -> initForEmails()
