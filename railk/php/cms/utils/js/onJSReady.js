/**
 * A modified version of Stefan Hayden's onJSReady Prototype plugin. 
 * http://www.stefanhayden.com/blog/2008/07/29/javascript-event-onjsready-fires-when-all-js-files-have-loaded/
 *
 * @author John-David Dalton <john.david.dalton[at]gmail[dot]com>
 * @usage
 *   Prototype.include(['test1.js','test2.js','test3.js']); // array OR
 *   Prototype.include('test1.js', 'test2.js', 'test3.js'); // separate arguments OR
 *   Prototype.include('test1.js,test2.js,test3.js');       // comma separated string OR 
 *
 *   document.observe('scripts:loaded', function(){ dependent_on_external_js() });
 */
Prototype.include = Object.extend(
  function() {
    var callee = arguments.callee,
     head = document.getElementsByTagName('HEAD')[0],
     args = Array.prototype.slice.call(arguments, 0);

    args._each(function(files) {
      if (Object.isString(files))
        files = files.split(',');
      
      callee.total += files.length;
      files._each(function(file) {
        head.appendChild(
          new Element('script', { type: 'text/javascript', src: file.strip() })
        )
        .observe('readystatechange', function () {
          if (!this.loaded && this.readyState === 'complete') {
            this.loaded = true;
            callee.downloaded++;
          }
        })
        .observe('load', function () {
          if (this.loaded) return;
          this.loaded = true;
          callee.downloaded++;
        }); // end observers
      }); // end files _each 
    }); // end args _each
  }, 
  {
    total: 0,
    downloaded: 0
  }
);

(function() {
  var timer;
  function ready() {
    if (arguments.callee.done) return;
    clearInterval(timer);
    arguments.callee.done = true;
    document.fire('scripts:loaded');
  }
  
  timer = setInterval(function() {
    var i = Prototype.include;
    if (i.total && i.downloaded === i.total) ready();
  }, 10);
})();