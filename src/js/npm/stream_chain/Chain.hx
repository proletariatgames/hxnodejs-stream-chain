package externs.npm.stream_chain;

import haxe.extern.EitherType;
import js.node.Stream.IStream;
import js.node.stream.Readable;
import js.node.stream.Writable;
import js.node.stream.Duplex;
import js.node.stream.Transform;

typedef TransformFunction = (chunk: Any, ?encoding: String) -> Any;
typedef StreamItem = EitherType<IStream, TransformFunction>;

typedef ChainNewOptions = {
  > DuplexNewOptions,
  var ?skipEvents: Bool;
}

/**
  Chain, which is returned by require('stream-chain'), is based on Duplex.
  It chains its dependents in a single pipeline optionally binding error events.
**/
@:jsRequire('stream-chain')
extern class Chain extends Duplex<Chain> {

  /**
  streams is an array of streams created by the constructor.
  Its values either Transform streams that use corresponding functions from a constructor parameter, or user-provided streams.
  All streams are already piped sequentially starting from the beginning.
  **/
  var streams(default, null):Array<IStream>;

  /**
  input is the beginning of the pipeline.
  Effectively it is the first item of streams.
  **/
  var input(default, null):IWritable;

  /**
  output is the end of the pipeline.
  Effectively it is the last item of streams.
  **/
  var output(default, null):IReadable;
  
  /**
  fns is an array. Its items can be one of:
  - Function. Allowed: regular functions, asynchronous functions, generator functions, asynchronous generator functions.
  - Array of regular functions.
  - Transform stream.
  - Duplex stream.
  - The very first stream can be Readable.
  - The very last stream can be Writable.
  - All falsy values are simply ignored.
  **/
  function new(fns:Array<StreamItem>, ?options:ChainNewOptions);

  static function chain(fns:Array<StreamItem>, ?options:ChainNewOptions) : Chain;
  static function make(fns:Array<StreamItem>, ?options:ChainNewOptions) : Chain;

  /**
  It is a procedure, which puts a value into a stream using the standard API: push().
  It extracts final and multiple values and pushes them to a stream skipping undefined, null, and Chain.none values.
  This way sanitize() can push to the stream from 0 to many values.

  Presently it interprets arrays as a wrapper for multiple values (the deprecated functionality).

  Node streams assign a special meaning to undefined and null, so these values cannot possibly go the streaming infrastructure and cannot be used unwrapped.
  Yet they are perfectly legal inside comp() pipes.
  **/
	static function sanitize(value:Any, stream:IStream):Void;
}
