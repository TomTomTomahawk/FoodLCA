INSERT INTO recipes (name, draft)
VALUES ('Cheese Burger', FALSE);

INSERT INTO recipes (name, draft)
VALUES ('Burger', FALSE);

SELECT id
FROM recipes
WHERE name = 'Cheese burger';


INSERT INTO ingredients (name,
                         carbon_intensity,
                         calorie_intensity,
                         quantity,
                         unit,
                         recipe_id)
VALUES ('Cheese', .6, .3, 10, 'g', 1),
       ('Minced beef', 10, 10, 200, 'g', 1),
       ('Lettuce', .1, .1, 50, 'g', 1);

INSERT INTO ingredients (name,
                         carbon_intensity,
                         calorie_intensity,
                         quantity,
                         unit,
                         recipe_id)
VALUES ('Minced beef', 10, 10, 200, 'g', 2),
       ('Lettuce', .1, .1, 50, 'g', 2);




SELECT * FROM ingredients WHERE recipe_id = 1;



SELECT * FROM ingredients WHERE recipe_id = (
    SELECT id
    FROM recipes
    WHERE name = 'Cheese burger'
    AND recipes.draft = FALSE
);


SELECT * FROM recipes
    INNER JOIN ingredients i
        ON recipes.id = i.recipe_id
    WHERE recipe_id = 1;
