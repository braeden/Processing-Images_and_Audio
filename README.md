#Images and Audio

For this assignment you will be creating a program that displays an image while playing an artistically-rendered audio file on loop. When a specific key is held down the image and audio should undergo a transformation where the change to the image and the change to the audio are analogous in some fashion. Consider the example program downloadable here. In this program an image of a cheetah is displayed while audio of a cheetah is played in the background. When a key is pressed an echo is added to the audio and the image is given an analogous horizontal ‘echo’.

Many different transformations are possible. Making an image blurry, for example, might correspond to adding reverb to audio. Or, darkening in image file might correspond to removing the high frequencies from audio (commonly referred to as “darkening” the audio). There is obviously some interpretation with this. You have some degree of artistic license to be creative with the way that your audio processing correlates with your image processing. But keep in mind that you will be asked to explain the correlation. How is the transformed audio like the transformed image? Are there similarities in the transformation algorithms, etc?

##Getting Started

- Download the demo program here.
- Read through the code. Run the program. Experiment with the code to figure out how it works.
- Find a complimentary image and audio file.
- Imagine a visual or audio effect that you want for your image or audio file respectively. Maybe look around at image or audio editing software for inspiration.
- Come up with an analogous effect for either your image or audio.
- Implement both algorithms in the demo program in place of my echo.
- Repeat steps 4-6 one or more times.

##Standard Edition (the only edition this time)
- Your program must implement at least two different image processing algorithms along with two artistically-related audio processing algorithms. These should be attached to different keys that are pressed.
- For both transformations, the audio processing MAY be done using tools present in a library like Minim/Ugen. You do NOT need to write processing code to “manually” manipulate individual audio sample values in your audio file. You can rely on methods and functions already available via the Minim/Ugen libraries.
- For both transformations, the image processing MUST be done by writing your own algorithms to manipulate the RGB and/or alpha values of the pixels. You may NOT rely on processing-provided methods like tint, for example, to change your image. 
- One of your image transformation algorithms must go beyond a one-to-one, pixel-to-pixel calculation. For example you might use weighted-averaged values of neighboring pixels to calculate the value of each new pixel. This process is explained well in the Shiffman, Processing book, in Chapter 7: Pixels Under a Microscope. 
- The transformed images and audio do not need to be saved as new files, although you can certainly do this if you wish to. But they must be displayed/played within the program. 
- You may not use the image processing algorithms that Shiffman presents in his book or the echo algorithm from the demo program as your final algorithms; although I highly advise you to start with either Shiffman’s or the demo program’s algorithms. Then make incremental changes until you have a sense for how these things work. This is a good way to learn. In the end, remember, the idea is to make something unique.
