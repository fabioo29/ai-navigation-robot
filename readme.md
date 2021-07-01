<!-- PROJECT LOGO -->
<br />
<p align="center">

  <h3 align="center">Ev3 navigation robot</h3>

  <p align="center">
    Computer Vision and Deep Learning based robot that can collect objects and readjust them
    <br />
  </p>
</p>



<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li><a href="#about">About</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About

Getting objects info          |  Readjusting objects
:-------------------------:|:-------------------------:
![Product Name Screen Shot](assets/gif1.gif) | ![Product Name Screen Shot](assets/gif2.gif)

<p style="text-align: justify;text-justify: inter-word;">
  
This project uses an algorithm (w/ user interface) enterily built with MATLAB to control an Ev3 Mindstorm robot.
The robot has a IP webcam on it that can send info to the algorithm in real time. The purpose of the robot is to realocate objetcs with similar looks.
To track the colors from the objects we used computer vision and to classify the type of the object(shape) we trained a Deep Learning NeuralNet based on AlexNet architecture. To make sure everything works fine we've prepared a Calibration Setup as a first step for the user with the GUI.
  
</p>

***Tested with*** [Colors: 'red', 'green', 'blue', 'orange', 'purple', 'yellow'] && [Shapes: 'circle', 'square', 'triangle']

***Built With*** 
[Matlab](https://www.mathworks.com/products/matlab.html) and
[Mindstorm Ev3](https://www.lego.com/en-us/product/lego-mindstorms-ev3-31313)

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.


<!-- CONTACT -->
## Contact

Fábio Oliveira - [LinkedIn](https://www.linkedin.com/in/fabioo29/) - fabiodiogo29@gmail.com

Project Link: [https://github.com/Fabio29/ComputerVision-DeepLearning](https://github.com/Fabioo29/ComputerVision-DeepLearning)  
Project built as a ECE student in Instituto Politécnico do Cavado e do Ave.

[gif-1]: resources/gif1.gif
[gif-2]: resources/gif2.gif
