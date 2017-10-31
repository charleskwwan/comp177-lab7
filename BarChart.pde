public class BarChart extends Chart{
  public Point[] pData;
  private float maxXLabelWidth, maxYLabelWidth;
  private String xLabel, yLabel;
  private float xMin, xMax, yMin, yMax;

  public BarChart(Data data, int chartX, int chartY, int chartWidth, int chartHeight){
    super(data, chartX, chartY, chartWidth, chartHeight);
    this.name = "BarChart";
    this.data = data;
    this.pData = new Point [data.size()];
    for (int i = 0; i < data.size(); i++) {
      this.pData[i] = new Point(data.get(i).isMarked(), data.get(i).getValue());
    }
    //xLabel = xText;
    //yLabel = yText;
    
    //maxXLabelWidth = this.calculateXLabelWidth();
    //maxYLabelWidth = this.calculateYLabelWidth();
    
    yMin = 0.0;
    yMax = 1.0;
    
    float tempYVal;
    
    for (int index = 0; index < data.size(); index++) {
      tempYVal = (float) pData[index].y;
      yMin = min(tempYVal, yMin);
      yMax = max(tempYVal, yMax);
    }
  }
  void drawData(float ratio, float chartX, float chartY, float yZero, float elementWidth, float padding) {
    for (int index = 0; index < pData.length; index++) {
      float elementHeight = (float )pData[index].y * ratio;
      float startX = chartX + (padding * (index + 1)) + (elementWidth * index);
      pData[index].setDims(startX, chartY + yZero - elementHeight, elementWidth, elementHeight);
      pData[index].drawBar();
      //rect(startX, chartY + yZero - elementHeight, elementWidth, elementHeight);
      // this line is the little tick mark beneath each bar
      //line(startX + (elementWidth/2), chartY + yZero + abs(max(-5, (-1 *abs(elementHeight)))), startX + (elementWidth/2), chartY + yZero - min(5, abs(elementHeight)));
    }
  }
  public void render(int x, int y, int w, int h) {
    float xLabelWidth = min(h/4, maxXLabelWidth);
    float yLabelWidth = min(w/4, maxYLabelWidth);
    float chartX = x + yLabelWidth;
    float chartY = y;
    float chartWidth = w - yLabelWidth;
    float chartHeight = h - xLabelWidth;
    fill(255);
    rect(x, y, w, h);
    // Print the rect for the chart outline
    rect(chartX, chartY, chartWidth, chartHeight);
        
    float range = yMax-yMin;
    float ratio = chartHeight/range;
    float yZero = yMax * ratio;
    //println(yMin, yMax, range, chartHeight, ratio, yZero);
    line(chartX, chartY+yZero, chartX + chartWidth, chartY + yZero);
    
    // Print the individual tick marks on the x axis    
    float elementToPaddingRatio = 3;
    float elementWidth = chartWidth / pData.length;
    float padding = 0;
    do {
      padding = elementWidth / (elementToPaddingRatio + 1);
      elementWidth = (chartWidth - (padding * (pData.length + 1))) / pData.length; // add 1 in order to add spacing on each side of the bars
    } while (elementWidth/padding >= elementToPaddingRatio);  
    
    drawData(ratio, chartX, chartY, yZero, elementWidth, padding);
    
    //pushMatrix();
    //textSize(15);
    //float xtw = textWidth(xLabel) + 1;
    //float ytw = textWidth(yLabel) + 1;
    //fill(0, 0, 0);
    //textAlign(CENTER, CENTER);
    //text(xLabel, w/2 - (xtw/2), y+h-20, xtw, 20);
    //translate(x + 10, y + (h/2));
    //rotate(PI/2.0);
    //text(yLabel, -ytw/2, -10, ytw, 20);
    //popMatrix();
  }

  @Override
  public void draw(){
    this.render(this.viewX, this.viewY, this.viewWidth, this.viewHeight);
    //stroke(0);
    //strokeWeight(1);
    //fill(255);
    //rect(this.viewX, this.viewY, this.viewWidth, this.viewHeight);
    //fill(0);
    //textSize(30);
    //textAlign(CENTER, CENTER);
    //text(this.name + "(" + this.data.size() + ")", this.viewCenterX, this.viewCenterY);
  }

}


public class Point {
  
  public Object x;
  public Object y;
  private float xCoord, yCoord, w, h;
 
  Point(Object xVal, Object yVal) {
    x = xVal;
    y = yVal;
  }
  
  public float x() {
    return xCoord + (w/2);
  }
  
  public float y() {
    return yCoord;
  }
  
  void drawBar() {
      if (this.hoverOver()) {
        fill(255);
        stroke(0);
        rect(xCoord, yCoord, w, h);
        toolTip();
      } else {
        fill(255);
        stroke(0);
        rect(xCoord, yCoord, w, h);
      }
      if ((boolean) this.x) {
        fill(0);
        ellipse(xCoord + (w/2), yCoord + (h / 2), 10, 10);
      }
    // all of this is just to make the text below the bars vertical
    //pushMatrix();
    //translate(xCoord, yCoord);
    //rotate(-HALF_PI);
    //translate(-xCoord, -yCoord);
    //textAlign(RIGHT);
    //textSize(10);
    //fill(0);
    //text(x.toString(), xCoord - h - 10, yCoord + w/2);
    //popMatrix();
  }
  
  void drawPoint() {
    if (this.hoverOver()) {
        fill(200);
        ellipse(xCoord + w/2, yCoord, 10, 10);
        toolTip();
      } else {
        fill(123, 48, 99);;
        ellipse(xCoord + w/2, yCoord, 10, 10);
      }
    // all of this shiz is just to make the text below the bars vertical
    //pushMatrix();
    //translate(xCoord, yCoord);
    //rotate(-HALF_PI);
    //translate(-xCoord, -yCoord);
    //textAlign(RIGHT);
    //textSize(10);
    //fill(0);
    //text(x.toString(), xCoord - h - 10, yCoord + w/2);
    //popMatrix();
  }
  
  void setDims(float X, float Y, float Width, float Height) {
    xCoord = X;
    yCoord = Y;
    w = Width;
    h = Height;
  }
  
  boolean hoverOver(){
    return ((mouseX > xCoord) && (mouseX < xCoord + w) && (mouseY > yCoord) && (mouseY < yCoord + h));
  }
  
  void toolTip() {
    fill(255);
    rect(mouseX - 90, mouseY - 17, 100, 25);
    fill(0);
    textAlign(RIGHT);
    text("( " + this.x + ", " + this.y + ")", mouseX, mouseY);
  }

}