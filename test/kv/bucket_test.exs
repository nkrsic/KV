defmodule KV.BucketTest do
  use ExUnit.Case, async: true

  test "stores values by key" do
    {:ok, bucket} = KV.Bucket.start_link([])
    assert KV.Bucket.get(bucket, "milk") == nil

    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.get(bucket, "milk") == 3
  end

  test "stores values by key on a named process" do
    {:ok, _} = KV.Bucket.start_link(name: :shopping_list)
    assert KV.Bucket.get(:shopping_list, "milk") == nil

    KV.Bucket.put(:shopping_list, "milk", 3)
    assert KV.Bucket.get(:shopping_list, "milk") == 3
  end

  test "stores values by key on a named process with config", config do
    {:ok, _} = KV.Bucket.start_link(name: config.test)
    assert KV.Bucket.get(config.test, "milk") == nil

    KV.Bucket.put(config.test, "milk", 3)
    assert KV.Bucket.get(config.test, "milk") == 3
  end

  test "deletes (pops) a value off the map", config do
    {:ok, _} = KV.Bucket.start_link(name: config.test)
    KV.Bucket.put(config.test, "milk", 3)

    assert KV.Bucket.delete(config.test, "milk") == 3
    assert KV.Bucket.get(config.test, "milk") == nil
  end

  test "alternate deletes (pops) a value off the map", config do
    {:ok, _} = KV.Bucket.start_link(name: config.test)
    KV.Bucket.put(config.test, "milk", 3)

    assert KV.Bucket.alt_delete(config.test, "milk") == 3
    assert KV.Bucket.get(config.test, "milk") == nil
  end
end
