require_relative '../helper'


module Statements
  include AST::Sexp

  def setup
    Register.machine.boot # force boot to reset main
  end

  def clean_compile(clazz_name , method_name , args , statements)
    compiler = Typed::Compiler.new.create_method(clazz_name,method_name,args ).init_method
    compiler.process( Typed.ast_to_code( statements ) )
  end

  def check
    assert @expect , "No output given"
    compiler = Typed::Compiler.new Register.machine.space.get_main
    produced = compiler.process( Typed.ast_to_code( @input) )
    produced = Register.machine.space.get_main.instructions
    compare_instructions produced , @expect
    produced
  end

  def compare_instructions instruction , expect
    index = 0
    start = instruction
    begin
      should = expect[index]
      assert should , "No instruction at #{index}"
      assert_equal instruction.class , should , "Expected at #{index+1}\n#{should(start)}"
      index += 1
      instruction = instruction.next
    end while( instruction )
  end
  def should start
    str = start.to_ac.to_s
    str.gsub!("Register::","")
    ret = ""
    str.split(",").each_slice(7).each do |line|
      ret += "                " + line.join(",") + " ,\n"
    end
    ret
  end
end
