package echos.core;


typedef Storage<T> = #if echos_array_cc ArrayComponentContainer<T>; #else IntMapComponentContainer<T>; #end


#if echos_array_cc

abstract ArrayComponentContainer<T>(Array<T>) {

    public inline function new() this = new Array<T>();

    public inline function add(id:Int, c:T) {
        this[id] = c;
    }

    public inline function get(id:Int):T {
        return this[id];
    }

    public inline function remove(id:Int) {
        this[id] = null;
    }

    public inline function exists(id:Int) {
        return this[id] != null;
    }

    public function dispose() {
        #if haxe3 
        this.splice(0, this.length);
        #else 
        this.resize(0);
        #end
    }

}

#else

@:forward(get, remove, exists)
abstract IntMapComponentContainer<T>(haxe.ds.IntMap<T>) {

    public function new() this = new haxe.ds.IntMap<T>();

    public inline function add(id:Int, c:T) {
        this.set(id, c);
    }

    public function dispose() {
        // for (k in this.keys()) this.remove(k); // python "dictionary changed size during iteration"
        var i = @:privateAccess echos.Workflow.nextId;
        while (--i > -1) this.remove(i); 
    }

}

#end
