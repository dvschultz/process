class Chunk {
	int x,y,w,h;	// coordinates,dimensions
	float txX,txY;	// texture normal
	PImage tx; 		// texture

	Chunk(int x, int y, int w, int h, PImage img, float txX, float txY) {
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
		this.tx = img;
		this.txX = (float) txX;
		this.txY = (float) txY;
	}

	void draw(boolean doTint) {
		beginShape(QUAD);
  		texture(tx);
  		if(doTint) tint(random(255), random(255), random(255));
  		drawQuad();
  		endShape();
	}

	void drawQuad() {
		float x1 = (float) x;
		float x2 = x1 + w;
		float y1 = (float) y;
		float y2 = y1 + h;

		float tx1 = norm(x1,0,width) + (txX/width); //normalized plus offset
		float tx2 = norm(x2,0,width) + (txX/width);
		float ty1 = norm(y1,0,height) + (txY/height);
		float ty2 = norm(y2,0,height) + (txY/height);

		// float tx1 = norm(x1,0,width) + (txX/tx.width); //normalized plus offset
		// float tx2 = norm(x2,0,width) + (txX/tx.width);
		// float ty1 = norm(y1,0,height) + (txY/tx.height);
		// float ty2 = norm(y2,0,height) + (txY/tx.height);

		vertex(x1, y1, tx1, ty1);
		vertex(x2, y1, tx2, ty1);
		vertex(x2, y2, tx2, ty2);
		vertex(x1, y2, tx1, ty2);
	}

	void moveTextureByY(int increment) {
		this.txY += increment;
	}
	void moveTextureByX(int increment) {
		this.txX += increment;
	}

}