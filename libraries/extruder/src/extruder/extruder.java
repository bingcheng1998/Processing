package extruder;

/**
 * Created by maxfa on 6/13/2017.
 */

import processing.core.*;

import static processing.core.PApplet.cos;
import static processing.core.PApplet.radians;
import static processing.core.PApplet.sin;
import static processing.core.PConstants.CLOSE;
import static processing.core.PConstants.QUADS;

public class extruder {
    public PApplet context;

    public extruder(PApplet cura){
        context = cura;
    }
    // TODO: Connect bottom
    // Draw and extrude the given points
    public PShape[] extrude(int[][] points, int[][] bpoints, int depth, int depthOffset, String edgeType){
        boolean calcBottom = true;
        if (points.length == bpoints.length){
            calcBottom = false;
        }
        PShape edges = context.createShape();
        // Start shape
        edges.beginShape(QUADS);
        // Contains the next point
        int[] next = new int[0];
        int[] nextBottom = new int[0];
        // Contains the current point
        int[] cur = new int[0];
        int[] curBottom = new int[0];
        // Starting point in points array
        int start = 0;
        // If edge type is triangle start at index 1
        if (edgeType == "triangle"){
            start = 1;
        }
        // Iterate through points array
        for (int it = start;it<points.length;it++){
            // Set current point
            cur = new int[] {points[it][0], points[it][1]};
            // Set next point
            if (it == (points.length - 1)){
                if (edgeType == "triangle"){
                    next = new int[] {points[1][0], points[1][1]};
                } else if (edgeType == "box"){
                    next = new int[] {points[0][0], points[0][1]};
                    if (calcBottom){
                        nextBottom = new int[] {points[0][0], points[0][1]};
                    } else {
                        nextBottom = new int[] {bpoints[0][0], bpoints[0][1]};
                    }
                }
            } else {
                next = new int[] {points[it+1][0], points[it+1][1]};
                if (calcBottom){
                    nextBottom = new int[] {points[it+1][0], points[it+1][1]};
                } else {
                    nextBottom = new int[] {bpoints[it+1][0], points[it+1][1]};
                }
            }
            if (calcBottom){
                curBottom = new int[] {points[it][0], points[it][1]};
            } else {
                curBottom = new int[] {bpoints[it][0], bpoints[it][1]};
            }
            // Draw vertices for current point
            edges.vertex(cur[0], cur[1], depthOffset);
            if (edgeType == "box"){
                edges.vertex(curBottom[0], curBottom[1], depth);
                edges.vertex(nextBottom[0], nextBottom[1], depth);
            } else if (edgeType == "triangle"){
                edges.vertex(points[0][0], points[0][1], depth);
            }
            edges.vertex(next[0], next[1], depthOffset);
            //edges.vertex(cur[0], cur[1], 0);

        }
        // Draw final point
        edges.vertex(next[0], next[1], depthOffset);
        if (edgeType == "box"){
            edges.vertex(nextBottom[0], nextBottom[1], depth);
        } else if (edgeType == "triangle"){
            edges.vertex(points[0][0], points[0][1], depth);
        }
        edges.vertex(next[0], next[1], depthOffset);
        // End shape
        edges.endShape(CLOSE);
        PShape bottom = context.createShape();
        bottom.beginShape();
        start = 0;
        if (edgeType == "triangle"){
            start = 1;
        }
        for (int it = start;it<points.length;it++){
            bottom.vertex(points[it][0], points[it][1], depthOffset);
        }
        bottom.endShape();
        if (edgeType.equals("triangle")) {
            return new PShape[] {edges, bottom};
        } else if (edgeType.equals("box")) {
            PShape top = context.createShape();
            top.beginShape();
            if (calcBottom) {
                for (int it = start; it < points.length; it++) {
                    top.vertex(points[it][0], points[it][1], depth);
                }
            } else {
                for (int it = start; it < bpoints.length; it++) {
                    top.vertex(bpoints[it][0], bpoints[it][1], depth);
                }
            }
            top.endShape();
            return new PShape[] {edges, bottom, top};
        } else {
            return new PShape[] {edges};
        }
    }

    // Gather points from given pshape and then draw and extrude them
    public PShape[] extrude(PShape shape, int depth, String edgeType){
        // Initialize points tracker
        int[][] points = new int[shape.getVertexCount()][2];
        // For each vertex, add the x and y of the vertex to points
        for (int i = 0; i < shape.getVertexCount(); i++) {
            PVector v = shape.getVertex(i);
            points[i] = new int[]{(int) v.x, (int) v.y};
        }
        // Pass points, depth, and edgeType to direct extrude method
        return extrude(points, new int[0][0], depth, 0, edgeType);
    }

    // Gather points from given pshape and then draw and extrude them
    public PShape[] extrude(PShape shape, PShape bottom, int depth, String edgeType){
        // Initialize points tracker
        int[][] points = new int[shape.getVertexCount()][2];
        // For each vertex, add the x and y of the vertex to points
        for (int i = 0; i < shape.getVertexCount(); i++) {
            PVector v = shape.getVertex(i);
            points[i] = new int[]{(int) v.x, (int) v.y};
        }
        int[][] pointsBottom = new int[bottom.getVertexCount()][2];
        for (int i = 0; i < bottom.getVertexCount(); i++) {
            PVector v = bottom.getVertex(i);
            pointsBottom[i] = new int[]{(int) v.x, (int) v.y};
        }
        // Pass points, depth, and edgeType to direct extrude method
        return extrude(points, pointsBottom, depth, 0, edgeType);
    }

    // This needs tweaking
    public PShape genPlane(int sides, int size){
        PShape tmp = context.createShape();
        // Start shape
        tmp.beginShape();
        // Draw vertices
        for (int it=0;it<sides + 1;it++){
            // The degree offset for the size in based on the number of angles
            int sideso = 360 / sides;
            int x = (int) (size * cos(radians(sideso * it)));
            int y = (int) (size * sin(radians(sideso * it)));
            // Add vertex
            tmp.vertex(x, y);
        }
        // End shape
        tmp.endShape();
        return tmp;
    }
}
