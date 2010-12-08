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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101208161543) do

  create_table "relationships", :force => true do |t|
    t.integer  "accessor_id"
    t.integer  "accessed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "accepted",    :default => false
  end

  add_index "relationships", ["accessed_id"], :name => "index_relationships_on_accessed_id"
  add_index "relationships", ["accessor_id"], :name => "index_relationships_on_accessor_id"

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",              :default => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "personal_email"
    t.string   "work_email"
    t.string   "username"
    t.string   "home_phone"
    t.string   "work_phone"
    t.string   "cell_phone"
    t.string   "service_provider"
  end

end
