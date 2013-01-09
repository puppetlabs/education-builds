<?php
/**
 * @file
 * Defines an associative array of Form Controls structure.
 *
 * @see http://api.drupal.org/api/drupal/developer!topics!forms_api_reference.html/7
 */

$description_options = '<p>' . t('The possible values this field can contain. Enter one value per line, in the format key|label.');
$description_options .= '<br/>' . t('The key is the stored value. The label will be used in displayed values and edit forms.');
$description_options .= '<br/>' . t('The label is optional: if a line contains a single string, it will be used as key and label.');
$description_options .= '</p>';

$description_php1 = t('You must have permission to either enter or modify the PHP code in this field.') . '<br />';
$description_php2 = t('Code example: !code Do NOT wrap it into the &lt;?php ?&gt; tags.');
$description_code_sample = "<h3>return array('myvalue');</h3>";

$form_controls = array(
  '#type'  => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'select',
        '#options' => array(
          'checkbox' => t('Checkbox'),
          'checkboxes' => t('Checkboxes'),
          'date' => t('Date'),
          'fieldset' => t('Fieldset'),
          'file' => t('File'),
          'machine_name' => t('Machine name'),
          'managed_file' => t('Managed file'),
          'password' => t('Password'),
          'password_confirm' => t('Password confirm'),
          'radio' => t('Radio'),
          'radios' => t('Radios'),
          'select' => t('Select'),
          'tableselect' => t('Table select'),
          'text_format' => t('Text format'),
          'textarea' => t('Text area'),
          'textfield' => t('Text field'),
          'vertical_tabs' => t('Vertical tabs'),
          'weight' => t('Weight'),
        ),
        '#empty_option' => t('- Select -'),
        '#required' => TRUE,
        '#ajax' => array(
          'callback' => '_composed_field_vertical_tabs_ajax_callback',
        ),
      ),
    ),
    'supported_types' => NULL,
  ),
  '#title' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textfield',
      ),
    ),
    'supported_types' => array(
      'checkbox',
      'checkboxes',
      'date',
      'fieldset',
      'file',
      'machine_name',
      'managed_file',
      'password',
      'password_confirm',
      'radio',
      'radios',
      'select',
      'text_format',
      'textarea',
      'textfield',
      'weight',
    ),
  ),
  '#description' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textfield',
      ),
    ),
    'supported_types' => array(
      'checkbox',
      'checkboxes',
      'date',
      'fieldset',
      'file',
      'machine_name',
      'managed_file',
      'password',
      'password_confirm',
      'radio',
      'radios',
      'select',
      'text_format',
      'textarea',
      'textfield',
      'weight',
    ),
  ),
  '#options' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textarea',
        '#title' => t('Allowed values list for') . ' ',
        '#description' => $description_options,
      ),
    ),
    'supported_types' => array('checkboxes','radios','select','tableselect'),
    'value process' => array('_composed_field_list_allowed_values_array'),
  ),
  '#prefix' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textfield',
      ),
    ),
    'supported_types' => array(
      'checkbox',
      'checkboxes',
      'date',
      'fieldset',
      'file',
      'machine_name',
      'managed_file',
      'password',
      'password_confirm',
      'radio',
      'radios',
      'select',
      'tableselect',
      'text_format',
      'textarea',
      'textfield',
      'vertical_tabs',
      'weight',
    ),
  ),
  '#suffix' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textfield',
      ),
    ),
    'supported_types' => array(
      'checkbox',
      'checkboxes',
      'date',
      'fieldset',
      'file',
      'machine_name',
      'managed_file',
      'password',
      'password_confirm',
      'radio',
      'radios',
      'select',
      'tableselect',
      'text_format',
      'textarea',
      'textfield',
      'vertical_tabs',
      'weight',
    ),
  ),
  '#required' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'checkbox',
        '#field_suffix' => '<b>' . t('Make it required') . '</b>',
        '#title' => t('Required') . ' ',
        '#title_display' => 'before',
        '#default_value' => TRUE,
      ),
    ),
    'supported_types' => array(
      'checkbox',
      'checkboxes',
      'date',
      'file',
      'machine_name',
      'password',
      'password_confirm',
      'radio',
      'radios',
      'select',
      'text_format',
      'textarea',
      'textfield',
      'weight',
    ),
  ),
  '#size' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textfield',
        '#element_validate' => array('element_validate_number'),
      ),
    ),
    'supported_types' => array(
      'file',
      'machine_name',
      'password',
      'password_confirm',
      'select',
      'textfield',
    ),
  ),
  '#maxlength' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textfield',
        '#element_validate' => array('element_validate_number'),
      ),
    ),
    'supported_types' => array('machine_name','textfield'),
  ),
  '#access' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'checkbox',
        '#title' => t('Make it unaccessable for') . ' ',
        '#default_value' => TRUE,
      ),
    ),
    'supported_types' => array(
      'checkbox',
      'checkboxes',
      'date',
      'fieldset',
      'file',
      'machine_name',
      'managed_file',
      'password',
      'password_confirm',
      'radio',
      'radios',
      'select',
      'tableselect',
      'text_format',
      'textarea',
      'textfield',
      'vertical_tabs',
      'weight',
    ),
  ),
  '#after_build' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textarea',
        '#description' => $description_php1 .
        t($description_php2, array('!code' => $description_code_sample)),
        '#element_validate' => array('composed_field_php_permission'),
      ),
    ),
    'supported_types' => array(
      'checkbox',
      'checkboxes',
      'date',
      'fieldset',
      'file',
      'machine_name',
      'managed_file',
      'password',
      'password_confirm',
      'radio',
      'radios',
      'select',
      'tableselect',
      'text_format',
      'textarea',
      'textfield',
      'vertical_tabs',
      'weight',
    ),
  ),
  '#attached' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textarea',
        '#description' => $description_php1 .
        t($description_php2, array('!code' => "<h3>return array('css' => array(drupal_get_path('module', 'ajax_example') . '/ajax_example.css',);</h3>")),
        '#element_validate' => array('composed_field_php_permission'),
      ),
    ),
    'supported_types' => array(
      'checkbox',
      'checkboxes',
      'date',
      'fieldset',
      'file',
      'machine_name',
      'managed_file',
      'password',
      'password_confirm',
      'radio',
      'radios',
      'select',
      'tableselect',
      'text_format',
      'textarea',
      'textfield',
      'vertical_tabs',
      'weight',
    ),
  ),
  '#element_validate' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textarea',
        '#description' => $description_php1 .
        t($description_php2, array('!code' => $description_code_sample)),
        '#element_validate' => array('composed_field_php_permission'),
      ),
    ),
    'supported_types' => array(
      'checkbox',
      'checkboxes',
      'date',
      'fieldset',
      'file',
      'machine_name',
      'managed_file',
      'password',
      'password_confirm',
      'radio',
      'radios',
      'select',
      'tableselect',
      'text_format',
      'textarea',
      'textfield',
      'vertical_tabs',
      'weight',
    ),
  ),
  '#parents' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textarea',
        '#description' => $description_php1 .
        t($description_php2, array('!code' => $description_code_sample)),
        '#element_validate' => array('composed_field_php_permission'),
      ),
    ),
    'supported_types' => array(
      'checkbox',
      'checkboxes',
      'date',
      'fieldset',
      'file',
      'machine_name',
      'managed_file',
      'password',
      'password_confirm',
      'radio',
      'radios',
      'select',
      'tableselect',
      'text_format',
      'textarea',
      'textfield',
      'vertical_tabs',
      'weight',
    ),
  ),
  '#post_render' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textarea',
        '#description' => $description_php1 .
        t($description_php2, array('!code' => $description_code_sample)),
        '#element_validate' => array('composed_field_php_permission'),
      ),
    ),
    'supported_types' => array(
      'checkbox',
      'checkboxes',
      'date',
      'fieldset',
      'file',
      'machine_name',
      'managed_file',
      'password',
      'password_confirm',
      'radio',
      'radios',
      'select',
      'tableselect',
      'text_format',
      'textarea',
      'textfield',
      'vertical_tabs',
      'weight',
    ),
  ),
  '#pre_render' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textarea',
        '#description' => $description_php1 .
        t($description_php2, array('!code' => $description_code_sample)),
        '#element_validate' => array('composed_field_php_permission'),
      ),
    ),
    'supported_types' => array(
      'checkbox',
      'checkboxes',
      'date',
      'fieldset',
      'file',
      'machine_name',
      'managed_file',
      'password',
      'password_confirm',
      'radio',
      'radios',
      'select',
      'tableselect',
      'text_format',
      'textarea',
      'textfield',
      'vertical_tabs',
      'weight',
    ),
  ),
  '#process' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textarea',
        '#description' => $description_php1 .
        t($description_php2, array('!code' => $description_code_sample)),
        '#element_validate' => array('composed_field_php_permission'),
      ),
    ),
    'supported_types' => array(
      'checkbox',
      'checkboxes',
      'date',
      'fieldset',
      'file',
      'machine_name',
      'managed_file',
      'password',
      'password_confirm',
      'radio',
      'radios',
      'select',
      'tableselect',
      'text_format',
      'textarea',
      'textfield',
      'vertical_tabs',
      'weight',
    ),
  ),
  '#states' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textarea',
        '#description' => $description_php1 .
        t($description_php2, array('!code' => $description_code_sample)),
        '#element_validate' => array('composed_field_php_permission'),
      ),
    ),
    'supported_types' => array(
      'checkbox',
      'checkboxes',
      'date',
      'fieldset',
      'file',
      'machine_name',
      'managed_file',
      'password',
      'password_confirm',
      'radio',
      'radios',
      'select',
      'tableselect',
      'text_format',
      'textarea',
      'textfield',
      'vertical_tabs',
      'weight',
    ),
  ),
  '#theme' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textfield',
        '#description' => t("The name of a theme function, without the initial 'theme_'"),
      ),
    ),
    'supported_types' => array(
      'checkbox',
      'checkboxes',
      'date',
      'fieldset',
      'file',
      'machine_name',
      'managed_file',
      'password',
      'password_confirm',
      'radio',
      'radios',
      'select',
      'tableselect',
      'text_format',
      'textarea',
      'textfield',
      'vertical_tabs',
      'weight',
    ),
  ),
  '#theme_wrappers' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textarea',
        '#description' => $description_php1 .
        t($description_php2, array('!code' => $description_code_sample)),
        '#description' => t("The name of a theme function, without the initial 'theme_'"),
        '#element_validate' => array('composed_field_php_permission'),
      ),
    ),
    'supported_types' => array(
      'checkbox',
      'checkboxes',
      'date',
      'fieldset',
      'file',
      'machine_name',
      'managed_file',
      'password',
      'password_confirm',
      'radio',
      'radios',
      'select',
      'tableselect',
      'text_format',
      'textarea',
      'textfield',
      'vertical_tabs',
      'weight',
    ),
  ),
  '#tree' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'checkbox',
        '#title' => t('Make it TRUE for') . ' ',
        '#default_value' => TRUE,
      ),
    ),
    'supported_types' => array(
      'checkbox',
      'checkboxes',
      'date',
      'fieldset',
      'file',
      'machine_name',
      'managed_file',
      'password',
      'password_confirm',
      'radio',
      'radios',
      'select',
      'tableselect',
      'text_format',
      'textarea',
      'textfield',
      'vertical_tabs',
      'weight',
    ),
  ),
  '#value_callback' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textfield',
        '#description' => t("A single function name to be called to set the value of this element."),
      ),
    ),
    'supported_types' => array(
      'checkbox',
      'checkboxes',
      'date',
      'fieldset',
      'file',
      'machine_name',
      'managed_file',
      'password',
      'password_confirm',
      'radio',
      'radios',
      'select',
      'tableselect',
      'text_format',
      'textarea',
      'textfield',
      'vertical_tabs',
      'weight',
    ),
  ),
  '#weight' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textfield',
        '#description' => t("A positive or negative number (integer or decimal)."),
        '#element_validate' => array('element_validate_number'),
      ),
    ),
    'supported_types' => array(
      'checkbox',
      'checkboxes',
      'date',
      'fieldset',
      'file',
      'machine_name',
      'managed_file',
      'password',
      'password_confirm',
      'radio',
      'radios',
      'select',
      'tableselect',
      'text_format',
      'textarea',
      'textfield',
      'vertical_tabs',
      'weight',
    ),
  ),
  '#title_display' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'select',
        '#options' => array(
          'before' => t('Before'),
          'after' => t('After'),
          'invisible' => t('Invisible'),
          'attribute' => t('Attribute (Supported only by checkboxes and radios)'),
        ),
      ),
    ),
    'supported_types' => array(
      'checkbox',
      'checkboxes',
      'date',
      'fieldset',
      'file',
      'machine_name',
      'managed_file',
      'password',
      'password_confirm',
      'radio',
      'radios',
      'select',
      'text_format',
      'textarea',
      'textfield',
      'weight',
    ),
  ),
  '#attributes' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textarea',
        '#description' => $description_php1 .
        t($description_php2, array('!code' => "<h3>return array('class' => array('search-form'));</h3>")),
        '#element_validate' => array('composed_field_php_permission'),
      ),
    ),
    'supported_types' => array(
      'checkbox',
      'checkboxes',
      'date',
      'fieldset',
      'file',
      'machine_name',
      'managed_file',
      'password',
      'radio',
      'radios',
      'select',
      'tableselect',
      'text_format',
      'textarea',
      'textfield',
      'weight',
    ),
  ),
  '#disabled' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'checkbox',
        '#title' => t('Make it TRUE for') . ' ',
        '#default_value' => TRUE,
      ),
    ),
    'supported_types' => array(
      'checkbox',
      'checkboxes',
      'date',
      'file',
      'machine_name',
      'managed_file',
      'password',
      'password_confirm',
      'radio',
      'radios',
      'select',
      'text_format',
      'textarea',
      'textfield',
      'weight',
    ),
  ),
  '#ajax' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textarea',
        '#description' => $description_php1 .
        t($description_php2, array('!code' => "<h3>return array('callback' => 'mycallbackfunction', 'wrapper' => 'mywrapper');</h3>")),
        '#element_validate' => array('composed_field_php_permission'),
      ),
    ),
    'supported_types' => array(
      'checkbox',
      'checkboxes',
      'machine_name',
      'radio',
      'radios',
      'select',
      'tableselect',
      'text_format',
      'textarea',
      'textfield',
    ),
  ),
  '#field_prefix' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textfield',
      ),
    ),
    'supported_types' => array(
      'checkbox',
      'machine_name',
      'password',
      'password_confirm',
      'radio',
      'select',
      'textarea',
      'textfield',
    ),
  ),
  '#field_suffix' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textfield',
      ),
    ),
    'supported_types' => array(
      'checkbox',
      'machine_name',
      'password',
      'password_confirm',
      'radio',
      'select',
      'textarea',
      'textfield',
    ),
  ),
  '#return_value' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textfield',
        '#description' => t('Value element should return when selected'),
      ),
    ),
    'supported_types' => array('checkbox','radio'),
  ),
  '#multiple' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'checkbox',
        '#title' => t('Make it TRUE for') . ' ',
        '#default_value' => TRUE,
      ),
    ),
    'supported_types' => array('select','tableselect'),
  ),
  '#cols' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textfield',
        '#element_validate' => array('element_validate_integer_positive'),
        '#description' => t('How many columns wide the textarea should be.'),
      ),
    ),
    'supported_types' => array('text_format','textarea'),
  ),
  '#resizable' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'checkbox',
        '#title' => t('Make it resizable for') . ' ',
        '#default_value' => TRUE,
      ),
    ),
    'supported_types' => array('text_format','textarea'),
  ),
  '#rows' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textfield',
        '#element_validate' => array('element_validate_integer_positive'),
        '#description' => t('How many rows high the textarea should be.'),
      ),
    ),
    'supported_types' => array('text_format','textarea'),
  ),
  '#autocomplete_path' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textfield',
        '#description' => t('The path the AJAX autocomplete script uses as the source for autocompletion.'),
      ),
    ),
    'supported_types' => array('machine_name','textfield'),
  ),
  '#collapsed' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'checkbox',
        '#title' => t('Make it collapsed for') . ' ',
        '#default_value' => TRUE,
      ),
    ),
    'supported_types' => array('fieldset'),
  ),
  '#collapsible' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'checkbox',
        '#title' => t('Make it collapsible for') . ' ',
        '#default_value' => TRUE,
      ),
    ),
    'supported_types' => array('fieldset'),
  ),
  '#group' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textfield',
        '#description' => t('A string where the value is used for the id of a form element with the #type of vertical_tabs.'),
      ),
    ),
    'supported_types' => array('fieldset'),
  ),
  '#empty_option' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textfield',
        '#description' => t('The label to show for the initial option denoting no selection in a select element. By default, the label is automatically set to "- Select -" for a required field and "- None -" for an optional field.'),
      ),
    ),
    'supported_types' => array('select'),
  ),
  '#empty_value' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textarea',
        '#description' => $description_php1 .
        t($description_php2, array('!code' => $description_code_sample)),
        '#element_validate' => array('composed_field_php_permission'),
      ),
    ),
    'supported_types' => array('select'),
  ),
  '#empty' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textfield',
        '#description' => t('Text to display if the #options property is empty.'),
      ),
    ),
    'supported_types' => array('tableselect'),
  ),
  '#header' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textarea',
        '#description' => $description_php1 .
        t($description_php2, array('!code' => $description_code_sample)),
        '#element_validate' => array('composed_field_php_permission'),
      ),
    ),
    'supported_types' => array('tableselect'),
  ),
  '#js_select' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'checkbox',
        '#title' => t('Make it TRUE for') . ' ',
        '#default_value' => TRUE,
      ),
    ),
    'supported_types' => array('tableselect'),
  ),
  '#default_tab' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textfield',
        '#description' => t('String containing the HTML ID of the fieldset element for the default tab.'),
      ),
    ),
    'supported_types' => array('vertical_tabs'),
  ),
  '#delta' => array(
    'widget_form' => array(
      'value' => array(
        '#type' => 'textfield',
        '#element_validate' => array('element_validate_integer_positive'),
        '#description' => t('Number of weights to have selectable. For example, with $delta => 10, the weight selection box would display numbers from -10 to 10.'),
      ),
    ),
    'supported_types' => array('weight'),
  ),

  // This item must always sit at the end of this structure.
  '#default_value' => array(
    'widget_form' => array(
      'value' => array(
        // We initially set the form element type to textfield which will
        // get updated to the user selected one on each ajax callback.
        '#type' => 'textfield',
      ),
    ),
    'supported_types' => array(
      'checkbox',
      'checkboxes',
      'date',
      'machine_name',
      'radio',
      'radios',
      'select',
      'tableselect',
      'text_format',
      'textarea',
      'textfield',
      'weight',
    ),
  ),
);
