/*:
 
 # Finder Zen AR
 
 **An extended** `ARKit+SceneKit` **remaster of my first ever** `Swift/SpriteKit` **game**
 
 ![Finder Zen AR logo/splash-art](title-hero.png)
 
 Created by Vincent C. (github.com/vince14genius)
 
 *Finder™ and the Finder icon are trademarks and sole intellectual properties of Apple Inc.*
 
*/

import ARKit

/*:
 
 ## Introduction
 
 For a better AR playground experience, **please**:
 
 * (optional) expand the live view to full screen
 
 * **(required)** allow the playground to use the camera for AR
 
 * **(required)** do not change orientation from one horizontal side to its opposite during the AR session
 
 * (optional) orient the iPad with the front camera on the left, if horizontal
 
 * remember to use the **Return** button on the **bottom left corner** if you don't know where the game is (or went)
 
 Just follow the short in-game tutorial to learn about the basic mechanics and the four types of bubbles. *Enjoy!*
 
 *The following line of code starts this playground experience:*
*/

TransitionController.instance.showTitleScreen()

/*:

 ---
 ---
 
 # Appendix
 
 After playing, if you want to know more about the background story or the specific stats of items in-game, read the following sections.
 
 ---
 
 ## Background Story
 
 ### Finder Zen (`SpriteKit`)
 
 [https://github.com/vince14genius/finder-zen](https://github.com/vince14genius/finder-zen)
 
 Finder lives in a universe where colorful bubbles are the source of energy and magical powers. 
 
 Help Finder meditate to practice the ways of the colorful bubbles, by protecting him from harm and allowing good bubbles to pass through.  
 
 ### Finder Zen 2 (`SpriteKit`)
 
 [https://github.com/vince14genius/finder-zen-2](https://github.com/vince14genius/finder-zen-2)
 
 Many many years ago, Finder lived in the App Village, practicing the ways of the colorful bubbles with his *sensei* (teacher/master), the Elder Finder (who looks like the Finder icon before the OS X Yosemite redesign). 
 
 One day, a wounded App ran in and reported the bad news: Androids are invading and laying waste to App Village! To protect the village, Finder and Elder Finder went on a journey to defeat the Dark Lord - *Android Boss*. 
 
 They made it through the guards, but Elder Finder fell from the Dark Lord's vicious attacks. Narrowly escaping, Finder carries on the Elder's legacy and promises revenge. 
 
 Finder continued practicing his powers (*insert Finder Zen screenshot*), until he finally mastered it. 
 
 First, Finder defeated all the Android guards roaming around the place he meditated in. 
 
 Then, Finder `swift`ly strikes through Android guards blocking his way. 
 
 Before reaching the Dark Lord's palace, he met an old friend - Terminal. It turned out that Terminal worked as a spy for Elder Finder at the enemy capital to learn their secrets. 
 
 Terminal challenged Finder to defeat her, to prove that he has the skills enough to beat the Dark Lord. Terminal used all the dark magic bubble tricks that she learned from the Androids. 
 
 After proving his strength, Finder left off for the Dark Lord's palace. After a very epic and tension-filled battle, Finder defeated the Dark Lord and restored peace to App Village and surrounding areas. 
 
 *Android is a trademark of Alphabet Inc. (if I remembered correctly)*
 
 ### Finder Zen AR (`ARKit + SceneKit`)
 
 **It's this playground!**
 
 Peace was restored, and Finder continued mastering the art of colorful bubbles. This time, Finder is equipped with new knowledge - the dark magic that Terminal showed him. 
 
 Finder strives to understand how to use dark magic for good, to uncover the ultimate secrets of the arcane energy in colorful bubbles, and to bring balance to the universe. 

 Help Finder achieve his enlightenment by, again, protecting him from harm and allowing good bubbles to pass through. This time, you're using *dark magic* bullets to achieve that. 
 
 ---
 
 ## Stats in Detail
 
 ### Specifics of each `Bullet`
 
    Direct Hit Bullet
    - Default shooting
    - Smaller hit box
 
    Modified Hit Bullet
    - Summoned by aiming at floating portals
    - Larger hit box
 
 ### Specifics of each `Bubble`
    Blue / ◯
    - No Hit:       Score +1
    - Direct Hit:   Destroyed
    - Modified Hit: Destroyed, spawn 4x Blue

    Red / ×
    - No Hit:       Game Over
    - Direct Hit:   Destroyed
    - Modified Hit: Destroyed, fires 1 `Modified Bullet` at nearest `Bubble`
 
    Green / ★
    - No Hit:       N/A
    - Direct Hit:   Powerup (4s, Score +10) destroying all Red/Yellow
    - Modified Hit: Powerup (8s, Score +20) destroying all Red/Yellow
 
    Yellow / !
    - No Hit:       N/A
    - Direct Hit:   Game Over
    - Modified Hit: Destroyed, spawn 1x Blue
 
 ---
 
 ## Debug options
 
 Tweek the following `ARKit` debug options for, as we all know, *debug purposes*.
 
*/

TransitionController.instance.arDebugOptions = [
    //.showPhysicsShapes,
    //.showWorldOrigin,
    .showFeaturePoints,  // I'm keeping this one because it looks cool
]

/*:
 
 Turn on this crazy cheat to experience the game with your default bullet being the Modified bullet!
 
 (Internally, I just use this cheat to help debugging, but it feels so awesome)
 
*/

isModifyBulletCheatOn = false

/*:
 
 ---
 
 ## Known Issues
 
 * The playground occasionally crashes when summoned Modified bullets hit targets
 ** Exact conditions of the bug unknown
 ** Observed to be happening when either one summoned Modified bullet hit multiple targets at once, or when two Modified bullets both hit a target (not exactly sure)
 ** Does not occur for Modified bullets directly fired when the cheat is on
 
*/
