class limits (
  $config    = undef,
  $use_hiera = true
) {
  if $use_hiera {
    $limits = hiera_hash('limits', $config)
  }
  else {
    $limits = $config
  }
  if $limits {
    create_resources( 'limits::domain', $limits )
  }
}
