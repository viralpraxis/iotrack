# frozen_string_literal: true

require 'securerandom'

require_relative '../lib/purist'

RSpec.describe Purist do
  describe '::TRACE_HANDLER' do
    context 'with match' do
      let(:trace_point) do
        instance_double(
          TracePoint,
          event: :c_call,
          path: 'some/path',
          lineno: 42,
          defined_class: Kernel,
          callee_id: :p,
          binding: []
        )
      end

      specify do
        expect { described_class::TRACE_HANDLER[trace_point] }
          .to raise_error(Purist::Errors::PurityViolationError)
      end
    end

    context 'without match' do
      let(:trace_point) do
        instance_double(
          TracePoint,
          event: :c_call,
          path: 'some/path',
          lineno: 42,
          defined_class: Integer,
          callee_id: :succ
        )
      end

      specify do
        expect { described_class::TRACE_HANDLER[trace_point] }
          .not_to raise_error
      end
    end
  end

  describe '.configuration' do
    its(:configuration) { is_expected.to be_an_instance_of(Purist::Configuration) }
  end

  describe '.trace' do
    context 'with pure code' do
      table = [
        {
          name: 'simple arithmetics',
          code: -> { 1.succ + 1 }
        },
        {
          name: 'module declaration',
          code: -> {}
        }
      ]

      table.each do |entry|
        context entry.fetch(:name) do
          specify do
            expect { described_class.trace { entry.fetch(:code)[] } }
              .not_to raise_error
          end
        end
      end
    end

    context 'with impure code' do
      table = {
        Kernel: {
          abort: [
            {
              name: 'in implicit manner',
              code: -> { abort }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.abort }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send(:abort) }
            }
          ],
          at_exit: [
            {
              name: 'in implicit manner',
              code: -> { at_exit }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.at_exit }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send(:at_exit) }
            }
          ],
          exit: [
            {
              name: 'in implicit manner',
              code: -> { exit }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.exit }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send(:exit) }
            }
          ],
          exit!: [
            {
              name: 'in implicit manner',
              code: -> { exit! }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.exit! }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send(:exit!) }
            }
          ],
          pp: [
            {
              name: 'in implicit manner',
              code: -> { pp :s }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.send(:pp, :s) }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send(:pp, :s) }
            }
          ],
          gets: [
            {
              name: 'in implicit manner',
              code: -> { gets }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.gets }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send(:gets) }
            }
          ],
          open: [
            {
              name: 'in implicit manner',
              code: -> { open 'bin/false' }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.open 'bin/false' }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send('open', 'bin/false') }
            }
          ],
          p: [
            {
              name: 'in implicit manner',
              code: -> { p 1 }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.p 1 }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send('p', 1) }
            }
          ],
          print: [
            {
              name: 'in implicit manner',
              code: -> { print }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.print }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send('print') }
            }
          ],
          printf: [
            {
              name: 'in implicit manner',
              code: -> { printf }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.printf }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send('printf') }
            }
          ],
          putc: [
            {
              name: 'in implicit manner',
              code: -> { putc }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.putc }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send('putc') }
            }
          ],
          puts: [
            {
              name: 'in implicit manner',
              code: -> { puts }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.puts }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send('puts') }
            }
          ],
          readline: [
            {
              name: 'in implicit manner',
              code: -> { readline }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.readline }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send('readline') }
            }
          ],
          readlines: [
            {
              name: 'in implicit manner',
              code: -> { readlines }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.readlines }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send('readlines') }
            }
          ],
          select: [
            {
              name: 'in implicit manner',
              code: -> { select }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.select }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send('select') }
            }
          ],
          set_trace_func: [
            {
              name: 'in implicit manner',
              code: -> { set_trace_func }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.set_trace_func }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send('set_trace_func') }
            }
          ],
          trace_var: [
            {
              name: 'in implicit manner',
              code: -> { trace_var }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.trace_var }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send('trace_var') }
            }
          ],
          untrace_var: [
            {
              name: 'in implicit manner',
              code: -> { untrace_var }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.untrace_var }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send('untrace_var') }
            }
          ],
          '``': [
            {
              name: 'in implicit manner',
              code: -> { `echo 1` }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.`'echo 1' }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send('`', 'echo 1') }
            }
          ],
          exec: [
            {
              name: 'in implicit manner',
              code: -> { exec('/bin/bash') }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.exec('/bin/bash') }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send('exec', 'echo 1') }
            }
          ],
          fork: [
            {
              name: 'in implicit manner',
              code: -> { exec('/bin/bash') }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.system('/bin/bash') }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send('`', 'echo 1') }
            }
          ],
          spawn: [
            {
              name: 'in implicit manner',
              code: -> { spawn }
            },
            {
              name: 'in explicit manner',
              code: -> { spawn }
            },
            {
              name: 'via Object',
              code: -> { spawn }
            }
          ],
          system: [
            {
              name: 'in implicit manner',
              code: -> { system('/bin/bash') }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.system('/bin/bash') }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send('system', 'echo 1') }
            }
          ],
          # autoload: [
          #   {
          #     name: "in implicit manner",
          #     code: -> { autoload(:B, "f") }
          #   },
          #   {
          #     name: "in explicit manner",
          #     code: -> { autoload(:B, "f") }
          #   },
          #   {
          #     name: "via Object",
          #     code: -> { autoload(:B, "f") }
          #   }
          # ],
          load: [
            {
              name: 'in implicit manner',
              code: -> { load }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.load }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send(:load) }
            }
          ],
          require: [
            {
              name: 'in implicit manner',
              code: -> { require }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.require }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send(:require) }
            }
          ],
          require_relative: [
            {
              name: 'in implicit manner',
              code: -> { require_relative 'f' }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.require_relative 'f' }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send(:require_relative, 'f') }
            }
          ],
          rand: [
            {
              name: 'in implicit manner',
              code: -> { rand }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.rand }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send(:rand) }
            }
          ],
          srand: [
            {
              name: 'in implicit manner',
              code: -> { srand }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.srand }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send(:srand) }
            }
          ],
          sleep: [
            {
              name: 'in implicit manner',
              code: -> { sleep }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.sleep }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send(:sleep) }
            }
          ],
          sprintf: [
            {
              name: 'in implicit manner',
              code: -> { sprintf }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.sprintf }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send(:sprintf) }
            }
          ],
          syscall: [
            {
              name: 'in implicit manner',
              code: -> { syscall }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.syscall }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send(:syscall) }
            }
          ],
          trap: [
            {
              name: 'in implicit manner',
              code: -> { trap }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.trap }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send(:trap) }
            }
          ],
          warn: [
            {
              name: 'in implicit manner',
              code: -> { warn }
            },
            {
              name: 'in explicit manner',
              code: -> { Kernel.warn }
            },
            {
              name: 'via Object',
              code: -> { Object.new.send(:warn) }
            }
          ]
        },
        IO: {
          binread: [
            {
              name: 'in implicit manner',
              code: -> { IO.binread '/dev/null' } # rubocop:disable Security/IoMethods
            }
          ]
        },
        Random: {
          bytes: [
            {
              name: 'in implicit manner',
              code: -> { Random.bytes 1 }
            },
            {
              name: 'in explicit manner',
              code: -> { Random.new.bytes 1 }
            }
          ],
          rand: [
            {
              name: 'in implicit manner',
              code: -> { Random.rand }
            },
            {
              name: 'in explicit manner',
              code: -> { Random.new.rand }
            }
          ],
          srand: [
            {
              name: 'in implicit manner',
              code: -> { Random.srand }
            },
            {
              name: 'in explicit manner',
              code: -> { Random.new.send(:srand) }
            }
          ],
          urandom: [
            {
              name: 'in implicit manner',
              code: -> { Random.urandom }
            }
          ]
        },
        SecureRandom: {
          bytes: [
            {
              name: 'in implicit manner',
              code: -> { SecureRandom.bytes 42 }
            }
          ],
          gen_random: [
            {
              name: 'in implicit manner',
              code: -> { SecureRandom.gen_random 1 }
            }
          ],
          alphanumeric: [
            {
              name: 'in implicit manner',
              code: -> { SecureRandom.alphanumeric }
            }
          ],
          base64: [
            {
              name: 'in implicit manner',
              code: -> { SecureRandom.base64 }
            }
          ],
          choose: [
            {
              name: 'in implicit manner',
              code: -> { SecureRandom.send(:choose, (1..10), 2) }
            }
          ],
          hex: [
            {
              name: 'in implicit manner',
              code: -> { SecureRandom.send(:hex) }
            }
          ],
          rand: [
            {
              name: 'in implicit manner',
              code: -> { SecureRandom.send(:rand) }
            }
          ],
          random_bytes: [
            {
              name: 'in implicit manner',
              code: -> { SecureRandom.send(:random_bytes) }
            }
          ],
          random_number: [
            {
              name: 'in implicit manner',
              code: -> { SecureRandom.send(:random_number) }
            }
          ],
          urlsafe_base64: [
            {
              name: 'in implicit manner',
              code: -> { SecureRandom.send(:urlsafe_base64) }
            }
          ],
          uuid: [
            {
              name: 'in implicit manner',
              code: -> { SecureRandom.send(:uuid) }
            }
          ]
        }
      }

      table.each do |module_name, methods|
        methods.each do |method_id, examples|
          context "with `#{module_name}.#{method_id}` method" do
            examples.each do |entry|
              context entry.fetch(:name) do
                specify do
                  expect { described_class.trace { entry.fetch(:code)[] } }
                    .to raise_error(described_class::Errors::PurityViolationError)
                end
              end
            end
          end
        end
      end
    end
  end
end
