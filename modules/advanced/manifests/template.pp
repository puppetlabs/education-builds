# Manage the file once based on a .old file in the same directory
define advanced::template (
  $extension    = 'erb',
  $replace_file = true,
  $file_path    = inline_template('<%= File.dirname(@title) %>'),
  $file_name    = inline_template('<%= File.basename(@title) %>'),
) {
  file { $title :
    ensure  => file,
    replace => $replace_file,
    content => template("${module_name}${file_path}/${file_name}.${extension}"),
  }
}
