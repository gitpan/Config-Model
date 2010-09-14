# 
# This file is part of Config-Model
# 
# This software is Copyright (c) 2010 by Dominique Dumont, Krzysztof Tyszecki.
# 
# This is free software, licensed under:
# 
#   The GNU Lesser General Public License, Version 2.1, February 1999
# 
# test model used by t/*.t

[
 {
  read_config  => [
                    {   backend => 'IniFile', 
                        config_dir => '/etc/',
                        file => 'test.ini',
                        auto_create => 1,
                    },
                  ],

  name => 'IniTest',

  element =>      [
                    [qw/foo bar/] => { 
                                      type => 'list',
                                      cargo => {
                                                type => 'leaf',
                                                value_type => 'uniline',
                                                }
                                     },

                    [qw/class1 class2/] => { 
                                            type => 'node',
                                            config_class_name => 'IniTest::Class'
                                           }
                  ]
  },
 {
  read_config  => [
                    {   backend => 'IniFile', 
                        config_dir => '/etc/',
                        file => 'test.ini',
                        auto_create => 1,
                        comment_delimiter => ';' ,
                    },
                  ],

  name => 'IniTest2',

  element =>      [
                    [qw/foo bar/] => { 
                                      type => 'list',
                                      cargo => {
                                                type => 'leaf',
                                                value_type => 'uniline',
                                                }
                                     },

                    [qw/class1 class2/] => { 
                                            type => 'node',
                                            config_class_name => 'IniTest::Class'
                                           }
                  ]
  },{
  name => 'IniTest::Class',
  element => [
              [qw/lista listb/] => {
                                    type => 'list',
                                    cargo => { 
                                              type => 'leaf',
                                              value_type => 'uniline',
                                             } ,
                                   },
             ]
 }
];



