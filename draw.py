import matplotlib
matplotlib.use('Agg')
import turtle
import sys
import json

# Culori alese de Antonia <3

def draw_rectangle(posx, posy, width, lenght, color, filled):
    rect = turtle.Turtle()
    rect.shape("circle")
    rect.color(color)
    rect.fillcolor(color)
    if filled:
        rect.begin_fill()
    rect.penup()
    rect.goto(posx, posy)
    rect.pendown()
    rect.forward(width)
    rect.right(90)
    rect.forward(lenght)
    rect.right(90)
    rect.forward(width)
    rect.right(90)
    rect.forward(lenght)
    rect.right(90)
    if filled:
        rect.end_fill()

def draw_triangle(posx, posy, lenght, color, filled):
    triangle = turtle.Turtle()
    triangle.shape("circle")
    triangle.color(color)
    triangle.fillcolor(color)
    if filled:
        triangle.begin_fill()
    triangle.penup()
    triangle.goto(posx, posy)
    triangle.pendown()
    for i in range(3):
        triangle.forward(lenght)
        triangle.left(120)
    if filled:
        triangle.end_fill()

def draw_circle(posx, posy, radius, color, filled):
    circle = turtle.Turtle()
    circle.shape("circle")
    circle.color(color)
    circle.fillcolor(color)
    if filled:
        circle.begin_fill()
    circle.penup()
    circle.goto(posx, posy)
    circle.pendown()
    circle.circle(radius)
    if filled:
        circle.end_fill()

def draw_hexagon(posx, posy, length, color, filled):
    hexagon = turtle.Turtle()
    hexagon.shape("circle")
    hexagon.color(color)
    hexagon.fillcolor(color)
    if filled:
        hexagon.begin_fill()
    hexagon.penup()
    hexagon.goto(posx,posy)
    hexagon.pendown()
    for i in range(6):
        hexagon.forward(length)
        hexagon.right(60)
    if filled:
        hexagon.end_fill()

def draw_heart(posx, posy, color, filled):
    heart = turtle.Turtle()
    heart.shape("circle")
    heart.color(color)
    heart.fillcolor(color)
    if filled:
        heart.begin_fill()
    heart.penup()
    heart.goto(posx,posy)
    heart.pendown()
    heart.left(140)
    heart.forward(112)
    for i in range(25):
        heart.right(8)
        heart.forward(8)
    heart.left(120)
    for i in range(25):
        heart.right(8)
        heart.forward(8)
    heart.forward(112)
    if filled:
        heart.end_fill()
    

def main():

    window = turtle.Screen()
    window.bgcolor("white")
    

    with open('translator_output.txt') as f:
        data = json.load(f)

    for obj in data:
        # print(data[obj])
        if data[obj]["shape"] == "rectangle":
            draw_rectangle(
                int(data[obj]["position"]["x"]),
                int(data[obj]["position"]["y"]),
                int(data[obj]["length"]),
                int(data[obj]["width"]),
                data[obj]["color"],
                data[obj]["filled"] == "true",
            )
        if data[obj]["shape"] == "triangle":
            draw_triangle(
                int(data[obj]["position"]["x"]),
                int(data[obj]["position"]["y"]),
                int(data[obj]["length"]),
                data[obj]["color"],
                data[obj]["filled"] == "true",
            )
        if data[obj]["shape"] == "circle":
            draw_circle(
                int(data[obj]["position"]["x"]),
                int(data[obj]["position"]["y"]),
                int(data[obj]["radius"]),
                data[obj]["color"],
                data[obj]["filled"] == "true",
            )
        if data[obj]["shape"] == "hexagon":
            draw_hexagon(
                int(data[obj]["position"]["x"]),
                int(data[obj]["position"]["y"]),
                int(data[obj]["length"]),
                data[obj]["color"],
                data[obj]["filled"] == "true",
            )
        if data[obj]["shape"] == "heart":
            draw_heart(
                int(data[obj]["position"]["x"]),
                int(data[obj]["position"]["y"]),
                data[obj]["color"],
                data[obj]["filled"] == "true",
            )

    window.exitonclick()


if __name__ == "__main__":
    main()


def test():
    # 1 rectangle
    draw_rectangle(0, 0, 100, 200, "blue", False)
    # 2 triangle
    draw_triangle(0, 0, 100, "purple", False)
    # 3 circle
    draw_circle(0, 0, 100, "green", False)
    # 4 hexagon
    draw_hexagon(0, 0, 200, "yellow", False)
    # 5 heart
    draw_heart(0, 0, "red", False)

    # 1 rectangle
    draw_rectangle(0, 0, 100, 200, "blue", True)
    # 2 triangle
    draw_triangle(0, 0, 100, "purple", True)
    # 3 circle
    draw_circle(0, 0, 100, "green", True)
    # 4 hexagon
    draw_hexagon(0, 0, 200, "yellow", True)
    # 5 heart
    draw_heart(0, 0, "red", True)