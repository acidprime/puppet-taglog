# You can use the following in hiera taglog::tags for data binding
class taglog(
  $tags = [],
){

  validate_array($tags)

  $hash = {
    'tags' => $tags,
  }

  file { "${settings::confdir}/taglog.yaml" :
    ensure  => 'file',
    content => inline_template('<%= @hash.to_yaml %>'),
  }
}
