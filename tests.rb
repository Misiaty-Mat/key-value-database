# frozen_string_literal: true

require 'test/unit'

require './memory'

class TestMemory < Test::Unit::TestCase
  def setup
    @memory = Memory.new
  end

  def test_set_and_get_var
    assert_equal 'NULL', @memory.get('a')
    @memory.set('a', '1')
    assert_equal '1', @memory.get('a')
    @memory.set('a', '10')
    assert_equal '10', @memory.get('a')
  end

  def test_delete_var
    @memory.set('c', '2')
           .delete('c')
    assert_equal 'NULL', @memory.get('a')
  end

  def test_count_vars
    @memory.set('d', '2')
           .set('e', '2')
           .set('f', '2')
    assert_equal 3, @memory.count('2')
  end

  # Transactions

  def test_no_transaction
    assert_equal 'NO TRANSACTION', @memory.commit
    assert_equal 'NO TRANSACTION', @memory.rollback
  end

  def test_transaction_flow
    @memory.begin
           .set('g', '1')
           .commit
    assert_equal '1', @memory.get('g')
  end

  def test_transaction_rollback
    @memory.set('h', '1')
           .set('i', '3')
           .begin
           .set('h', '2')
           .delete('i')
           .set('j', '1')
           .rollback
    assert_equal '1', @memory.get('h')
    assert_equal '3', @memory.get('i')
    assert_equal 'NULL', @memory.get('j')
  end

  def test_embedded_transaction
    @memory.set('k', '1')
           .set('l', '1')
           .begin
           .set('k', '2')
           .begin
           .set('k', '3')
           .delete('l')
           .set('m', '2')
           .rollback
    assert_equal '2', @memory.get('k')
    assert_equal '1', @memory.get('l')
    assert_equal 'NULL', @memory.get('m')
    @memory.commit
  end

  def test_close_all_transactions_on_commit
    @memory.begin
           .begin
           .commit
    assert_equal 'NO TRANSACTION', @memory.rollback
  end
end
