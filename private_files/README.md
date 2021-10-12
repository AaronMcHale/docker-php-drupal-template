# Private files

This directory can be used by Drupal for private file storage.

## How to use

This directory is mounted in relevant containers at `/app/private_files`.

To enable private file storage, in `web/sites/default/settings.php`, replace:

```
# $settings['file_private_path'] = '';
```

With:

```
$settings['file_private_path'] = '/app/private_files';
```

Remember to clear the Drupal cache after changing this otherwise private files may not be available.
