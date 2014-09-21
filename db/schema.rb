<<<<<<< HEAD
# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140920225416) do

  create_table "entries", force: true do |t|
    t.string   "node"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationships", force: true do |t|
    t.integer  "parent"
    t.integer  "child"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
=======
# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140920225416) do

  create_table "entries", force: true do |t|
    t.string   "node"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entries", ["node"], name: "node_index"

  create_table "relationships", force: true do |t|
    t.integer  "parent"
    t.integer  "child"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["parent", "child"], name: "child_parent_index"
  add_index "relationships", ["type"], name: "type_index"

end
>>>>>>> 6856022d2ca1cfed96315d37ec5694cac055fa65
