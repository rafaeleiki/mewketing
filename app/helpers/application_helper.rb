module ApplicationHelper
  def snackbar_notifications(notice, alert)
    snackbar = '<div id="noticesnackbar" class="mdl-js-snackbar mdl-snackbar">
      <div class="mdl-snackbar__text"></div>
      <button class="mdl-snackbar__action" type="button"></button>
    </div>'

    if notice
      snackbar += '<script type="text/javascript">
        window.onload = setTimeout(function () {
          var snackbarContainer = document.getElementById("noticesnackbar");
          var data = {
            message: "' + notice + '",
            timeout: 5000
          };
          snackbarContainer.MaterialSnackbar.showSnackbar(data);
        }, 500);
    </script>'

    end

    if alert
      snackbar += '<script type="text/javascript">
      window.onload = setTimeout(function () {
        var snackbarContainer = document.getElementById("noticesnackbar");
        var data = {
          message: "' + alert + '",
          timeout: 5000
        };
        snackbarContainer.MaterialSnackbar.showSnackbar(data);
      }, 500);
    </script>'

    end

    return snackbar
  end


  def get_style_classes(item_name)
    case item_name
      # Button
    when 'btn-show'
      'mdl-button mdl-js-button mdl-button--raised mdl-button--colored'
    when 'btn-back'
      'mdl-button mdl-js-button mdl-button--raised'
    when 'btn-edit'
      'mdl-button mdl-js-button mdl-button--raised'
    when 'btn-destroy'
      'mdl-button mdl-js-button mdl-button--raised mdl-button--accent'
    when 'btn-new'
      'mdl-button mdl-js-button mdl-button--raised mdl-button--colored'
    when 'btn-add'
      'mdl-button mdl-js-button mdl-button--raised mdl-button--colored'

      # Title
    when 'h1-title'
      'mdl-typography--display-4'

      # Form
    when 'form-input-div'
      'mdl-textfield mdl-js-textfield'

    when 'form-label-text-input'
      'mdl-textfield__label'
    when 'form-text-input'
      'mdl-textfield__input'

    when 'form-label-checkbox-input'
      'mdl-checkbox mdl-js-checkbox mdl-js-ripple-effect'
    when 'form-span-label-checkbox-input'
      'mdl-checkbox__label'
    when 'form-checkbox-input'
      'mdl-checkbox__input'

    when 'form-submit'
      'mdl-button mdl-js-button mdl-button--raised mdl-button--colored'

    else
      ''
    end
  end
end
