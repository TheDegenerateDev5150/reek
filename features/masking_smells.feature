@masking
Feature: Masking smells using config files
  In order to keep my reports meaningful
  As a developer
  I want to mask some smells using config files

  Scenario: empty config file is ignored
    When I run reek spec/samples/empty_config_file/dirty.rb
    Then it fails with exit status 2
    And it reports:
      """
      spec/samples/empty_config_file/dirty.rb -- 6 warnings:
        Dirty has the variable name '@s' (Uncommunicative Name)
        Dirty#a calls @s.title twice (Duplication)
        Dirty#a calls puts(@s.title) twice (Duplication)
        Dirty#a has the name 'a' (Uncommunicative Name)
        Dirty#a/block has the variable name 'x' (Uncommunicative Name)
        Dirty#a/block/block is nested (Nested Iterators)

      """

  Scenario: corrupt config file prevents normal output
    When I run reek spec/samples/corrupt_config_file/dirty.rb
    Then it fails with exit status 1
    And it reports the error 'Error: Invalid configuration file "corrupt.reek" -- not a Hash'

  Scenario: missing source file is an error
    When I run reek no_such_file.rb
    Then it fails with exit status 1
    And it reports the error "Error: No such file or directory - no_such_file.rb"

  Scenario: switch off one smell
    When I run reek spec/samples/masked/dirty.rb
    Then it fails with exit status 2
    And it reports:
      """
      spec/samples/masked/dirty.rb -- 3 warnings (+3 masked):
        Dirty#a calls @s.title twice (Duplication)
        Dirty#a calls puts(@s.title) twice (Duplication)
        Dirty#a/block/block is nested (Nested Iterators)

      """

  Scenario: switch off one smell but show all in the report
    When I run reek --show-all spec/samples/masked/dirty.rb
    Then it fails with exit status 2
    And it reports:
      """
      spec/samples/masked/dirty.rb -- 3 warnings (+3 masked):
        (masked) Dirty has the variable name '@s' (Uncommunicative Name)
        Dirty#a calls @s.title twice (Duplication)
        Dirty#a calls puts(@s.title) twice (Duplication)
        (masked) Dirty#a has the name 'a' (Uncommunicative Name)
        (masked) Dirty#a/block has the variable name 'x' (Uncommunicative Name)
        Dirty#a/block/block is nested (Nested Iterators)

      """

  Scenario: switch off one smell and show hide them in the report
    When I run reek --no-show-all spec/samples/masked/dirty.rb
    Then it fails with exit status 2
    And it reports:
      """
      spec/samples/masked/dirty.rb -- 3 warnings (+3 masked):
        Dirty#a calls @s.title twice (Duplication)
        Dirty#a calls puts(@s.title) twice (Duplication)
        Dirty#a/block/block is nested (Nested Iterators)

      """

  Scenario: non-masked smells are only counted once
    When I run reek spec/samples/not_quite_masked/dirty.rb
    Then it fails with exit status 2
    And it reports:
      """
      spec/samples/not_quite_masked/dirty.rb -- 5 warnings (+1 masked):
        Dirty has the variable name '@s' (Uncommunicative Name)
        Dirty#a calls @s.title twice (Duplication)
        Dirty#a calls puts(@s.title) twice (Duplication)
        Dirty#a has the name 'a' (Uncommunicative Name)
        Dirty#a/block/block is nested (Nested Iterators)

      """