(function() {
  var Graph, poly,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  poly = this.poly || {};

  Graph = (function() {

    function Graph(spec) {
      this.render = __bind(this.render, this);
      this.merge = __bind(this.merge, this);
      var merge, _ref,
        _this = this;
      this.graphId = _.uniqueId('graph_');
      this.spec = spec;
      this.strict = (_ref = spec.strict) != null ? _ref : false;
      this.layers = [];
      if (spec.layers == null) spec.layers = [];
      _.each(spec.layers, function(layerSpec) {
        var layerObj;
        layerObj = poly.layer.make(layerSpec, spec.strict);
        return _this.layers.push(layerObj);
      });
      merge = _.after(this.layers.length, this.merge);
      _.each(this.layers, function(layerObj) {
        return layerObj.calculate(merge);
      });
    }

    Graph.prototype.merge = function() {
      var spec, tmpRanges;
      spec = this.spec;
      this.domains = {};
      if (spec.guides) {
        if (spec.guides == null) spec.guides = {};
        this.domains = poly.domain.make(this.layers, spec.guides, spec.strict);
      }
      tmpRanges = poly.dim.ranges(poly.dim.guess(this.spec));
      this.scaleSet = poly.scale.make(spec.guides, this.domains, tmpRanges);
      this.axes = this.scaleSet.getAxes();
      this.legends = this.scaleSet.getLegends();
      this.dims = poly.dim.make(spec, this.axes, this.legends);
      this.scaleSet.setRanges(poly.dim.ranges(this.dims));
      this.scales = this.scaleSet.getScaleFns();
      return this.ticks = this.axes;
    };

    Graph.prototype.render = function(dom) {
      var paper, render,
        _this = this;
      dom = document.getElementById(dom);
      paper = poly.paper(dom, this.dims.width, this.dims.height);
      this.clipping = poly.dim.clipping(this.dims);
      render = poly.render(this.graphId, paper, this.scales, this.clipping);
      return _.each(this.layers, function(layer) {
        return layer.render(paper, render);
      });
    };

    return Graph;

  })();

  poly.chart = function(spec) {
    return new Graph(spec);
  };

  this.poly = poly;

}).call(this);
