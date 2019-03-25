# WWDC19-Finder-Zen-AR
My WWDC 2019 Scholarship submission playground

![image banner](banner.png)

**Finder Zen AR**

The extended ARKit+SceneKit remastered version of [Finder Zen](https://www.github.com/vince14genius/finder-zen/)

## Tell us about the features and technologies you used in your Swift playground. 

**= UNIQUE GAMEPLAY FEATURES =**

- Striking the green power-up bubble releases a powerful shockwave that clears harmful bubbles and rewards 10 points

- Glowing & futuristic appearance with carefully chosen colors applied throughout

- Innovative Modified bullet summoning mechanism; the special bubble abilities activated by the Modified bullet truly add another layer of fun and delight into the game

- (decorative) make a stand for the hologram below Finder’s platform whenever a nearby horizontal plane is detected

**= TECHNOLOGIES =**

The game primarily uses ARKit + SceneKit to display gameplay content. The ARSCNView’s pointOfView property is used for the player to perform basic actions like navigate, aim, and shoot. ARKit is also used to detect planes so that the in-game hologram stand can actually stand on the floor. 

SceneKit’s particle systems and physically-based rendering (powered by Metal) are used to enhance the game’s graphics. 

SCNAction is used very frequently, especially for handling events in an automated, asynchronous run loop. It has almost everything that Timer in Foundation offers, but with more SceneKit-related features and much easier to use. 

Certain SceneKit features such as constraints, and techniques such as limiting rotation to the Euler angle’s y-axis, are also utilized as workarounds against the lack of advanced mathematical knowledge about 3D rotations. 

UIKit and Auto Layout is used to create the user interface, and to make sure that the interface works well on different screen sizes. 

Some of the most modern features of Swift, such as generics, protocols, enums, access control, extensions, and Markup are utilized to make the code easier to maintain throughout the 10-day period and perhaps beyond. A design pattern, that mostly follows the principles of object-oriented programming (message-sending, inheritance, encapsulation, etc.) but also incorporates the ideas of functional programming, is also implemented throughout the project. 

The Swift image literals and color literals are used in code whenever possible for various reasons. Color literals provide a straightforward and intuitive preview for the color values beings used in the project. Image literals are a reliable way to directly reference images, because it eliminates the possibility of typos, which occurs often in filename strings. In addition, I believe that a more intuitive and graphical way to work with certain parts of code is the future of programming. 

The image editing software Pixelmator Pro was used to create all UI images and the textures used on the Finder 3D model.

## Credits

Finder™ and the Finder icon are trademarks of Apple Inc. Apple is the sole owner of the trademarks. 

The ARKit mark is a resource provided by Apple on [developer.apple.com](https://developer.apple.com) .

The front face texture of the Finder model is created by myself, based on the Apple Finder icon.

All other images, including the imagined top, bottom, left, right, and back sides of Finder’s 3D model, are entirely original. All particle systems are original. 
