call coffee --compile GameOfLife.coffee
call coffee --compile wrappers.coffee

git add .
git commit -m "compiled coffeescript to javascript"
git push heroku master