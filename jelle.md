## Learning goals

To get the most out of the masters project we decided to work together as a group of five on the new minor website. But to actually get the most out of it we made some learning goals. Based on these we made plan to help each other out. My goals were to learn more about performance, write better (modular) JavaScript and get more creative with design.

### Performance matters

As build tool we chose to use Gulp. Gulp was pretty easy to understand for us and some of u

- **Gzip**
  Adding GZIP was easy but gives a big performance boost. All I had to do was installing [compression](https://github.com/expressjs/compression) and add this code to the `server.js`.

  ```javascript
  const compression = require("compression");
  app.use(compression());
  ```

- **Image compression**
  Image compression I did using a Gulp package called: [gulp-imagemin](https://www.npmjs.com/package/gulp-imagemin). When running the production build command `gulp build` images will now first be copied to the `static` folder and then compressed. The code looks like this:

  ```javascript
  const source = "./src/";
  const destination = "./static/";

  gulp.task("img:compress", function() {
    return gulp
      .src(source + "img/**/*")
      .pipe(imagemin())
      .pipe(gulp.dest(destination + "img"));
  });
  ```

- **Minfiy**
  Minifying is also done using Gulp. Both the CSS and the JS is being minified in two separate tasks:

  ```Javascript
  gulp.task("js:minify", () => {
    let bundler = browserify(source + "js/app.js", { debug: true }).transform(
      "babelify",
      { presets: ["env"] }
    );

    bundler
      .bundle()
      .on("error", function(err) {
        console.error(err);
        this.emit("end");
      })
      .pipe(sourceStream("app.js"))
      .pipe(buffer())
      .pipe(uglify())
      .pipe(sourcemaps.init({ loadMaps: true }))
      .pipe(sourcemaps.write("./"))
      .pipe(gulp.dest(destination + "js/"));
  });

  gulp.task("css:minify", () => {
    return gulp
      .src(destination + "css/**/*.css")
      .pipe(cleanCSS())
      .pipe(gulp.dest(destination + "css"));
  });
  ```

- **Browserify**
  At first we copied all the seperate JS files to the `static` folder. Later I added Browserify to reduce the amount of requests and improve the performance.

  ```Javascript
  gulp.task("js", function() {
    let bundler = browserify(source + "js/app.js", { debug: true }).transform(
      "babelify",
      { presets: ["env"] }
    );

    bundler
      .bundle()
      .on("error", function(err) {
        console.error(err);
        this.emit("end");
      })
      .pipe(sourceStream("app.js"))
      .pipe(buffer())
      .pipe(sourcemaps.init({ loadMaps: true }))
      .pipe(sourcemaps.write("./"))
      .pipe(gulp.dest(destination + "js/"));
  });
  ```

* **Building**
  To ensure that all images are getting compressed I used [gulp-sequence](https://www.npmjs.com/package/gulp-sequence) to first copy all the images and other assets and then optimize it.

  ```javasript
  gulp.task(
    "build",
    gulpSequence(
      "clean",
      ["sass", "js", "img"],
      ["js:minify", "css:minify", "img:compress"]
    )
  );
  ```

* **Loading using JSON files**
  Another thing I tried was to load the content of the pages directly from the JSON files. I didn't know if it would be faster to load it into memory first and then pass it to the Nunjucks rendering engine or to convert te JSON directly. After testing it turned out to not make a difference so I loaded it directly from the JSON files.

  ```javascript
  const fs = require("fs");

  function readData(path) {
    let data = fs.readFileSync(path, "utf8");
    return JSON.parse(data);
  }

  app.get("/", function(req, res) {
    res.render("index.html", {
      data: readData("src/json/homepage.json")
    });
  });
  ```

### Web app from scratch

Another thing I wanted to improve was the skill of building modular JavaScript. I did this using the export method of Browserify and combining it with a class. It was the first time I used classes and it is pretty cool. This way I could easily make multiple `presentation` or `subtitle` components without repeating the code.

```javascript
// subtitle.js
module.exports = class Subtitles {
  constructor(element, subtitles, mouseEventElement, presentationObj) {
    // ...code...
  }
};

// presentation.js
module.exports = class Presentation {
  constructor(element, slides, subtitleObj) {
    // ...code...
  }
};

// importing it in app.js
const Presentation = require("./presentation");
const Subtitles = require("./subtitles");

// Making a component
const fpSubtitles = new Subtitles(
  document.querySelector(".subtitle"),
  subs,
  document.querySelector(".presentation .media")
);

const fpPresentation = new Presentation(
  document.querySelector(".presentation"),
  slides,
  fpSubtitles
);
```

A thing I still want to add to make the components less depending on each other is to add custom event listeners. Sadly I didn't have enough time to try these out. I learned a lot while making `presentation.js` and `subtitles.js`. More of that later.

### More out of the box design

For the header of the website I came up with, I think, a pretty cool idea. The idea was to give the visitors of the website a taste of the minor already. And what is a better way then letting them diving straight into code?

The header shows the code that is used to build up some parts of the header. Everybody that I show the header think it fits very good with the minor and says it looks cool... mission accomplished!

![Homepage](https://d.pr/i/DuFm0H+)

## Program page

I worked a lot on the program page together with Jamal. We learned it was one of the most important pages of the website when testing with Marie. The first version we showed her wasn't very nice. The hierarchy was bad and the connections of the weeks and courses weren't that clear. The next version we showed Marie was a lot better, according to her.

![timeline-old](https://d.pr/i/iBrqdX+)

![final result](https://d.pr/i/Dqdh9M+)

## Video player

For deaf people it is hard to follow lectures. They have to focus on the speaker, the interpreter and the slides at the same time. As we are making a website for a minor lectures are part of it. To make it easier for deaf people to follow the lectures I made a video player focused on improving this experience. We tested the video player with Marie, a deaf graphic designer. She gave us a lot of interesting feedback. With this feedback we improved the video player to it's current form. A cool thing fo it is that the server reads SRT files that is as common format for subtitles.

**The [video player](https://redesign-minor.kager.io/program/weekly-nerd/vitaly-friedman) contains the following features:**

- Synced split screen view of the lecture and the slides
- Subtitles (loaded as SRT format).
- The subtitles can switch side using the mouse or arrow keys.
- Slide overview to quickly navigate trough the lecture
- The possibility to slowdown or speed up the lecture.
- The video player can be controlled using the keyboard.

![Screenshot of the video player](https://d.pr/i/tQJ6Uu+)

So I did build this component using clean and efficient JavaScript. I broke up the functionality in as many functions as possible to improve reuse of them. You can find these files here:

- [presentation.js](https://github.com/jelleoverbeek/redesign-minor-web-dev/blob/develop/app/src/js/presentation.js)
- [subtitles.js](https://github.com/jelleoverbeek/redesign-minor-web-dev/blob/develop/app/src/js/subtitles.js)

## Conclusion

It was interesting to work with a group of five people on this project. At first I thought five people were to lot for a "small" site like this but that wasn't true. We needed all the time and couldn't do everything we wanted to do. A thing I found very hard was to keep the specificity of the CSS low. This didn't went too well at all times. I think in the future we can decrease the specificity by NOT using SCSS anymore.

Teamwork and planning is still a hard thing in development. We used Github projects to maintain an overview of all the issues that were open and made pull requests to check each others work. At some times we had to tell each other to keep doing this to maintain a better code quality.

I learned a lot while building this website and I'm happy that I achieved the goals I wanted to. As always, there are some thing I want to improve but this will always be the case.

I was skeptical about Browserify the first time I used it (while following the course "performance matters") but now I really like it. I was skeptical because I didn't understand it very well.

It was nice to work and inspiring to work with Marie and Marijn. They thought us a lot about the web and how to design inclusively. Vasilis did a good job by pushing us to try out new things for them.

## Pull requests

You can find my pull requests [here](https://github.com/baskager/redesign-minor-web-dev/pulls?q=is%3Apr+is%3Aclosed+author%3Ajelleoverbeek).
