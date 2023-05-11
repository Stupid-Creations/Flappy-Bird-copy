class quad {
  int w;
  int h;

  PVector pos;
  PVector max;
  PVector min;
  PVector vel;

  quad(int xa, int ya, int rwidth, int rheight) {
    w = rwidth;
    h = rheight;

    pos = new PVector(xa, ya);
    vel = new PVector();

    min = pos;
    max = new PVector(pos.x+w, pos.y+h);
  }

  void render() {
    rect(pos.x, pos.y, w, h);
  }

  void update() {
    min = pos;
    max = new PVector(pos.x+w, pos.y+h); 
    pos.add(vel);
    vel.limit(5);
  }    

  void apply_force(PVector force) {
    vel.add(force);
  }
  boolean collide(quad a) {
    return !(max.x<a.min.x||max.y<a.min.y||min.x>a.max.x||min.y>a.max.y);
  }
}

class bird {
  int x;
  int y;

  quad body;

  boolean alive;

  bird(int xp, int yp) {
    x = xp;
    y = yp;

    body = new quad(x, y, 40, 40);

    alive = true;
  }

  void update() {
    body.render();   
    body.update();


    if (body.pos.y<=0) {
      alive = false;
    }
    if (body.pos.y+40>=400) {
      alive = false;
      body.pos.y = 400-40;
      fill(255,0,0);
    }
  }

  void gravity() {
    body.apply_force(new PVector(0, 0.3));
  }

  void jump() {
    if (alive) {
      body.vel.set(new PVector(0, -7));
    }
  }
}

ArrayList<quad> pipes = new ArrayList<quad>();

void setup() {
  size(400, 400);
  frameRate(60);
  int x = 0;
  int y = 0;
  for (int i =0; i<6; i++) {
    x += 75;
    if (i%2 ==0) {
      y = (int)random(-75, 0);
    } else {
      y = (int)random(300, 375);
    }
    pipes.add(new quad(x, y, 45, 200));
  }
}

bird a = new bird(100, 200);

void draw() {
  background(0);
  a.update();
  a.gravity();

  for (int i = 0; i<6; i++) {
    pipes.get(i).render();
    if (a.alive) {
      pipes.get(i).pos.x-=1;
    }
    pipes.get(i).update();
    if (pipes.get(i).pos.x < -45) {
      pipes.get(i).pos.x = 445;
      if (i%2 ==0) {
        pipes.get(i).pos.y = (int)random(-75, 0);
      } else {
        pipes.get(i).pos.y = (int)random(250, 375);
      }
    }
  }
  if (mousePressed) {
    a.jump();
  }
  for (int i =0; i<6; i++) {
    if (pipes.get(i).collide(a.body)==true) {    
      a.alive = false;
    }
  }
}
