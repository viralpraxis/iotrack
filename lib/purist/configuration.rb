# frozen_string_literal: true

require 'singleton'

module Purist
  class Configuration # rubocop:disable Metrics/ClassLength
    include Singleton

    Subject = Class.new do
      def self.from_module(module_name:, method_names:, with_singleton_class: false)
        targets = {}

        method_names.each do |method_name|
          targets[[module_name, method_name]] = true
          targets[[module_name.singleton_class, method_name]] = true if with_singleton_class
        end

        targets
      end
    end

    STDLIB_RANDOM_CLASS =
      if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.0.0')
        Random::Base
      else
        Random
      end

    TRACE_TARGETS = {
      **Subject.from_module(
        module_name: Kernel,
        with_singleton_class: true,
        method_names: %i[
          abort
          at_exit
          exit
          exit!

          pp
          gets
          open
          p
          print
          printf
          putc
          puts
          readline
          readlines
          select

          set_trace_func
          trace_var
          untrace_var

          `
          exec
          fork
          spawn
          system

          load
          require
          require_relative

          rand
          srand

          sleep
          sprintf
          syscall
          trap

          autoload
          warn
        ]
      ),
      **Subject.from_module(
        module_name: IO.singleton_class,
        method_names: %i[
          new
          for_fd
          open
          pipe
          popen
          select

          binread
          read
          readlines

          binwrite
          write

          foreach

          copy_stream
          try_convert

          sysopen
        ]
      ),
      **Subject.from_module(
        module_name: IO,
        method_names: %i[
          getbyte
          getc
          gets
          pread
          read
          read_nonblock
          readbyte
          readchar
          readline
          readlines
          readpartial

          print
          printf
          putc
          puts
          pwrite
          write
          write_nonblock

          pos
          pos=
          ropen
          rewind
          seek

          each
          each_byte
          each_char
          each_codepoint

          autoclose=
          binmode
          close
          close_on_exec
          close_read
          close_write
          set_encoding
          set_encoding_by_bom
          sync=

          fdatasync
          flush
          fsync
          ungetbyte
          ungetc

          advise
          fcntl
          ioctl
          sysread
          sysseek
          syswrite
        ]
      ),
      **Subject.from_module(
        module_name: Random.singleton_class,
        with_singleton_class: true,
        method_names: %i[
          bytes
          rand
          srand
          urandom
        ]
      ),
      **Subject.from_module(
        module_name: STDLIB_RANDOM_CLASS,
        method_names: %i[
          bytes
          rand
        ]
      )
    }.freeze

    def trace_targets
      TRACE_TARGETS
    end

    def action_on_purity_violation
      :raise
    end
  end
end
