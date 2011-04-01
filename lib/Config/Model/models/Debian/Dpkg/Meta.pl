#
# This file is part of Config-Model
#
# This software is Copyright (c) 2011 by Dominique Dumont, Krzysztof Tyszecki.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
[
  {
    'class_description' => 'This class contains parameters to tune the behavior of the Dpkg model. For instance, user can specify rules to update e-mail addresses.',
    'read_config' => [
      {
        'auto_create' => '1',
        'file' => '.dpkg-meta.yml',
        'backend' => 'Yaml',
        'config_dir' => '~/'
      }
    ],
    'name' => 'Debian::Dpkg::Meta',
    'copyright' => [
      '2010,2011 Dominique Dumont'
    ],
    'author' => [
      'Dominique Dumont'
    ],
    'license' => 'LGPL2',
    'element' => [
      'email-updates',
      {
        'cargo' => {
          'value_type' => 'uniline',
          'type' => 'leaf'
        },
        'summary' => 'email update hash',
        'type' => 'hash',
        'description' => 'Specify old email as key. The value is the new e-mail address that will be substituted',
        'index_type' => 'string'
      },
      'dependency-filter',
      {
        'value_type' => 'enum',
        'type' => 'leaf',
        'description' => 'Specifies the dependency filter to be used. The release specified mentions the most recent release to be filtered out. Older release will also be filtered.

For instance, if the dependency filter is \'lenny\', all \'lenny\' and \'etch\' dependencies are filtered out.',
        'choice' => [
          'etch',
          'lenny',
          'squeeze',
          'wheezy'
        ]
      },
      'package-dependency-filter',
      {
        'cargo' => {
          'compute' => {
            'formula' => '$group_filter',
            'variables' => {
              'maintainer' => '! control source Maintainer',
              'group_filter' => '- group-dependency-filter:"$maintainer"'
            },
            'allow_override' => '1'
          },
          'value_type' => 'enum',
          'type' => 'leaf',
          'choice' => [
            'etch',
            'lenny',
            'squeeze',
            'wheezy'
          ]
        },
        'type' => 'hash',
        'description' => 'Dependency filter tuned by package. Use this to override the main dependency-filter value.',
        'index_type' => 'string'
      },
      'group-dependency-filter',
      {
        'cargo' => {
          'compute' => {
            'formula' => '$main',
            'variables' => {
              'main' => '- dependency-filter'
            },
            'allow_override' => '1'
          },
          'value_type' => 'enum',
          'type' => 'leaf',
          'choice' => [
            'etch',
            'lenny',
            'squeeze',
            'wheezy'
          ]
        },
        'default_with_init' => {
          'Debian Perl Group <pkg-perl-maintainers@lists.alioth.debian.org>' => 'lenny'
        },
        'type' => 'hash',
        'description' => 'Dependency filter tuned by Maintainer field. Use this to override the main dependency-filter value.',
        'index_type' => 'string'
      }
    ]
  }
]
;

