# About Hanappe

Hanappe is a very simple and powerful framework.<br>
Runs on MOAISDK Version1.0 rev3.<br>

# Future
## 1. Application classes
The abstraction of the initialization of Window, the logic of the size of View.<br>

* Application ... This is the initialization of the application.Hold information about the environment.

## 2. Display classes
To simplify the generation of the display object.<br>

* Layer ... Based on the class MOAILayer.<br>
* Sprite ... Texture draw class.<br>
* SpriteSheet ... Sheet draw class.<br>
* MapSprite ... Grid draw class.<br>
* TextLabel ... MOAITextBox draw class.<br>
* Graphics ... Easy to handle MOAIDraw.<br>
* Group ... Grouping the MOAIProp.<br>
* Animation ... To simplify the animation.<br>

## 3. Manager classes
To cache textures and fonts, memory efficiency is improved.<br>
Responsible for management of input and scenes.<br>

* SceneManager ... To manage multiple scenes.<br>
* InputManager ... To manage the input operation.<br>
* TextureManager ... Manages to cache the Texture.<br>
* FontManager ... Manages to cache the Font.<br>

## 4. Tiled Map classes
To support the TMX file to read and draw.<br>

* TMXMapLoader ... Read TMX files.
* TMXMapView ... TMXMap View class.

## 5. RPG Map Classes
Reference implementation of RPGMap.

* RPGMapView ... Reference implementation of RPGMap
