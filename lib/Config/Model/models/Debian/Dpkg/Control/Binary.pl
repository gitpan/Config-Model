#
# This file is part of Config-Model
#
# This software is Copyright (c) 2010 by Dominique Dumont, Krzysztof Tyszecki.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
[
          {
            'name' => 'Debian::Dpkg::Control::Binary',
            'element' => [
                           'Architecture',
                           {
                             'value_type' => 'uniline',
                             'mandatory' => '1',
                             'type' => 'leaf'
                           },
                           'Section',
                           {
                             'value_type' => 'uniline',
                             'type' => 'leaf'
                           },
                           'Priority',
                           {
                             'value_type' => 'uniline',
                             'type' => 'leaf'
                           },
                           'Essential',
                           {
                             'value_type' => 'boolean',
                             'type' => 'leaf'
                           },
                           'Depends',
                           {
                             'cargo' => {
                                          'value_type' => 'uniline',
                                          'type' => 'leaf'
                                        },
                             'type' => 'list'
                           },
                           'Recommends',
                           {
                             'cargo' => {
                                          'value_type' => 'uniline',
                                          'type' => 'leaf'
                                        },
                             'type' => 'list'
                           },
                           'Breaks',
                           {
                             'cargo' => {
                                          'value_type' => 'uniline',
                                          'type' => 'leaf'
                                        },
                             'type' => 'list'
                           },
                           'Replaces',
                           {
                             'cargo' => {
                                          'value_type' => 'uniline',
                                          'type' => 'leaf'
                                        },
                             'type' => 'list'
                           },
                           'Conflicts',
                           {
                             'cargo' => {
                                          'value_type' => 'uniline',
                                          'type' => 'leaf'
                                        },
                             'type' => 'list'
                           },
                           'Provides',
                           {
                             'cargo' => {
                                          'value_type' => 'uniline',
                                          'type' => 'leaf'
                                        },
                             'type' => 'list'
                           },
                           'Suggests',
                           {
                             'cargo' => {
                                          'value_type' => 'uniline',
                                          'type' => 'leaf'
                                        },
                             'type' => 'list'
                           },
                           'Description',
                           {
                             'value_type' => 'string',
                             'mandatory' => '1',
                             'type' => 'leaf'
                           }
                         ]
          }
        ]
;
