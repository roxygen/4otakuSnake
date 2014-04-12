package lime;


import lime.utils.Assets;


class AssetData {

	private static var initialized:Bool = false;
	
	public static var library = new #if haxe3 Map <String, #else Hash <#end LibraryType> ();
	public static var path = new #if haxe3 Map <String, #else Hash <#end String> ();
	public static var type = new #if haxe3 Map <String, #else Hash <#end AssetType> ();	
	
	public static function initialize():Void {
		
		if (!initialized) {
			
			path.set ("assets/data/data-goes-here.txt", "assets/data/data-goes-here.txt");
			type.set ("assets/data/data-goes-here.txt", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/images/images-go-here.txt", "assets/images/images-go-here.txt");
			type.set ("assets/images/images-go-here.txt", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/images/orin.png", "assets/images/orin.png");
			type.set ("assets/images/orin.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/skull.png", "assets/images/skull.png");
			type.set ("assets/images/skull.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/suika_sprite.png", "assets/images/suika_sprite.png");
			type.set ("assets/images/suika_sprite.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/music/music-goes-here.txt", "assets/music/music-goes-here.txt");
			type.set ("assets/music/music-goes-here.txt", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/sounds/ghostGotcha.wav", "assets/sounds/ghostGotcha.wav");
			type.set ("assets/sounds/ghostGotcha.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("assets/sounds/smb_gameover.wav", "assets/sounds/smb_gameover.wav");
			type.set ("assets/sounds/smb_gameover.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("assets/sounds/sounds-go-here.txt", "assets/sounds/sounds-go-here.txt");
			type.set ("assets/sounds/sounds-go-here.txt", Reflect.field (AssetType, "text".toUpperCase ()));
			
			
			initialized = true;
			
		} //!initialized
		
	} //initialize
	
	
} //AssetData
