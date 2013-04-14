# Release notes

## Version 2.1.1 (Update: 2013/04/15)

I've implemented around the extension of the Flower.

### Test Version
Moai SDK Version 1.3 Build 160

Moai SDK Release 1.4p0 + [#660](https://github.com/moai/moai-dev/pull/660)

V1.4 compatibility is broken.
Please be careful.

### Flower Library

* Add a function to get a range of content NineImage.
* Work better when the trim of TexturePacker.
* Change the logic of setting the size of the Group.
* Optimizing EventDispatcher.
* Modified so that it can not be touched during the transition of the Scene.
* Modified so that it can close multiple scenes.
* Change in the texture filter GL_LINEAR.

### Flower Extensions

* Change the file name of the module.
* Add many widgets.(Button, ListBox, TextInput etc…)

### Hanappe Framework

* Improve the memory leak.
* Improvement to be able to disable the spooling function MsgBox.
* Improve the operation of the Scroller.
* Add a convenient function TMXMapView.
* Change in the texture filter GL_LINEAR.


## Version 2.1.0 (Update: 2013/02/17)

I made ​​a lot of improvements.
I also improved the document.

### Test Version
Moai SDK Version 1.3 Build 160

### Flower Library

* LDoc changed from LuaDoc.
* Improve the Readme.
* Documentation updates.
* Viewport has been modified to be resized when the Window is resized.
* Add a NineImage. Displays the NinePatch of Android.
* GetSize function to add a DisplayObject.  
  This was added to no longer work when getDims returns a negative value.
* Fixed bug when TexturePacker trim options have been set. (Thank you, superquadratic)
* Fixed a bug that can not change the size of the Image. (Thank you, Quad)
* Other small fixes.

### Flower Extensions

I added the extension of Flower Library.
However, this feature is not stable.  
Please use caution this extension.

* Add a class for TileMapEditor.
* Add a small GUI library.
* Other, there are still some debris.

### Hanappe Framework

* LDoc changed from LuaDoc.
* Improve the Readme.
* Documentation updates.
* I've changed the structure of the main.lua.  
  Compatibility This fix is lost a little.
  (global.lua -> modules.lua, deleted init.lua, config.lua)
* Fixed a bug in the drawing order of TMXMapView.
* Work better when you select the MessageBox. (Thank you, Eric)
* Scroller modified so that the bound. (Thank you, Eric)
* Add some features to Animation. (Thank you, Eric)
* Other small fixes.


## Version 2.0.2 (Update: 2013/01/02)

I made ​​a few important fixes.

### Test Version
Moai SDK Version 1.3 Build 160

### Flower Library

* Documentation updates. (Thanks Felix Gallo!)
* Rename the function.  
  table.insertElement to table.insertIfAbsent.  
  Executors.callLater to Executors.callOnce.
* Refactoring openWindow.
* Improve the Group to be included as a child of the Group.
* Update event to add the Scene.

### Hanappe Framework

* Fixed a bug in the Application:isMobile function.

## Version 2.0.1 (Update: 2012/12/08)

### Test Version
Moai SDK Version 1.3 Build 98

### Flower Library

I've created a lightweight library.
Flower is a library that can be used by itself.

### Hanappe Framework

I have fixed some small bugs.

## Version 2.0.0 (Update: 2012/10/07)

I made ​​a big fix for the portion GUI.
Compatible part is impaired.

### Test Version
Moai SDK Version 1.3 Build 98

### Hanappe Framework

* I have changed the configuration directory of the project.
* I had to rebuild the implementation of the GUI.
* I've added a method to detect touch events DisplayObject.
* Improvement how to set the initial properties of the DisplayObject.

## Version 1.5.1 (Update: 2012/07/17)

There is no significant modification.
Has a minor bug fixes.

### Test Version
Moai SDK Version 1.2 Build 56

### Hanappe Framework
* Some refactoring in the file.
* Add functions to the ResourceManager.
* Modify the pop-up effect of MessageBox.
* Add useful functions to delay execution of Executors.
* Scene add an event to be sent.
* Add functions to the Group.
* Others, such as bug fixes.

## Version 1.5.0 (Update: 2012/07/01)

### Test Version
Moai SDK Version 1.2 Build 56

### Hanappe Framework
In this version, we have a lot of improvements and refactoring.
Some care must be taken, so compatibility has been lost.

* Change the path of the Application.  
<br>
Before: require("hp/Application")  
After : require("hp/core/Application")

* Renaming a Method of Application.  
<br>
Before: Application:appStart()  
After : Application:start()

* Change on how to import the class.  
Available classes has increased in Hanappe.
Was changed to the class how to be aware that use the framework to be imported.  
<br>
Before: Application:import(t, prefix)  
After : classes.import(t)

* Added ResourceManager.  
Description has become easier by using the ResourceManager.
Makes it easy to switch over the resource.
In addition, the conventional method is also possible.
<br>
Before: Sprite(filePath)  
After : Sprite(fileName)

* Added SoundManager.
* Added Particles.  
Add a class for easy use of the Particle.
However, still many problems.
In addition, there is a bug in the MOAI SDK.
pex file can not be interpreted correctly.

* Has re-written in English of the source document.
* Others, such as improvement bug.

## Version 1.4.2 (Moai SDK Version 1.1 Revision 1)

Modify:If the string params of the DisplayObject.

* Refactoring:sample.
* Fixed:Bug fixes of Physics
* Fixed:table.removeElement bug fixes

## Version 1.4.1 (Moai SDK Version 1.1 Revision 1)

* Added:Mesh etc.
* Added:Add a function to resize Group.
* Added:PhysicsWorld, PhysicsBody, PhysicsFixture.(Prototype)
* Fixed:Fixed a bug in function wait (Animation).
* Fixed:Fixed a bug in Graphics.
* Fixed:Fixed a problem when the scale of the View is different.
* Modify:Change the order of class inheritance.

## Version 1.4.0 (Moai SDK Version 1.1 Revision 1)

* Refactoring:sample.
* Fixed:setVisible work around a bug in the MOAITextBox.
* Modify:Group setting when setCenterPiv, change so as not to move the upper left coordinates
* Modify:Change the method of generating an instance of the DisplayObject.
* Modify:TextureDrawable When you first set the texture, change it to resize.
* Modify:Change to MOAIProp from MOAITransform, an instance of the Group.
* Modify:Has inherited the DisplayObject EventDispatcher.
* Modify:Change the order of succession to the constructor of the class.
* Added:In touch with events, changes can be detected moving distance.
* Added:Add useful functions to MOAIPropUtil.
* Added:Add a pop-up display function in a MessageBox.

## Version 1.3.0 (Moai SDK Version 1.1 Revision 1)

* Added:CompareUtil
* Fixed:work around a bug and it is not working windows MOAIXmlParser.parseFile.
* Modify:RPGSprite move logic.
* Modify:Inheritable change the theme of the widget.
* Modify:Change the style of the button.
* Modify:Change the name of the function of WidgetManager.

## Version 1.2.2 (Moai SDK Version 1.0 Revision 3)

* Added:ScrollView,Panel,MessageBox,BoxLayout,HBoxLayout,VBoxLayout
* Modify:how to generate an instance of the class (__cal)
* Fixed:bug

## Version 1.2.1 (Moai SDK Version 1.0 Revision 3)

* Fixed:samples

## Version 1.2.0 (Moai SDK Version 1.0 Revision 3)

* Modify:Modify the name of the function of DisplayObjects. (setRectSize -> setSize)
* Added:NinePatch
* Added:Widget classes(Button,RadioButton)

## Version 1.1.5 (Moai SDK Version 1.0 Revision 3)

* Added:TMXMapLoader supported format.

## Version 1.1.4 (Moai SDK Version 1.0 Revision 3)

* Added:RPGMapView sample.

## Version 1.1.3 (Moai SDK Version 1.0 Revision 3)

* Modify:Joystick.

## Version 1.1.2 (Moai SDK Version 1.0 Revision 3)

* Fixed:Joystick.

## Version 1.1.1 (Moai SDK Version 1.0 Revision 3)

* Added:Joystick widget.
* Modify:RPGMapView.
* Fixed:Overall bug fixes.

## Version 1.1.0 (Moai SDK Version 1.0 Revision 3)

* Added:Animation clear function.
* Added:class base system.
* Added:RPGMapView.
* Fixed:TMXDisplay Fixed a bug in the Y coordinate of the SpriteSheet.
* Modify:internal logic.
* Modify:Change the structure of the directory of the package.
* Deleted:TMXMapFactory

## Version 1.0.0 (Moai SDK Version 1.0 Revision 3)

* Fixed:TMXDisplay tileNo bug fix.

## Version 0.9.8 (Moai SDK Version 1.0 Revision 3)

* Updated:TextureManager and FontManager of weak references table.
* Added:Logger.
* Fixed:Refactoring.

## Version 0.9.7 (Moai SDK Version 1.0 Revision 3)

* Added:luadoc.
* Added:Add the "useInputManager" option in the config
* Fixed:Refactoring(Scene, Samples).

