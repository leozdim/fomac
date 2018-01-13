namespace :import do
  desc "TODO"
  task db: :environment do
    ActiveRecord::Base.logger = Logger.new STDOUT
    ActiveRecord::Base.transaction do
      q=OldDb
      accouts=q.exec 'select * from accounts where step=8'
      accouts.each do |a|
        user=create_user a
        old_projects=q.exec "select * from project_registry where account_id=#{a['account_id'].to_i}"
        old_projects.each do |op|
          project=create_project user, op
        end
      end
    end
  end

end

def create_user a
  full_name=a['name'].split(' ')
  password=Time.now
  User.create!(:first_name=>full_name[0..1].join(' '),:last_name=>full_name[1],:second_last_name=>full_name[2],
               :role=>:creator, :email=>a['email'],:password=>password, :password_confirmation=>password, :account_active=>false )
end
def create_project user,op 
  category_id=1
  case op['categoria']
  when 'Creadores con trayectoria'
    category_id=2
  when 'Desarrollo artístico individual'
    category_id=3
  when 'Jóvenes creadores'
    category_id=1
  when 'Producción artística colectiva'
    category_id=4
  end
  art_form_id=1
  case op['disciplina']
  when 'Artes visuales'
    art_form=1
  when 'Cine y video'
    art_form=5
  when 'Danza'
    art_form=2
  when 'Letras'
    art_form=6
  when 'Música'
    art_form=3
  when 'Teatro'
    art_form=4
  end
  art=ArtForm.find art_form_id
  Project.create!(:user=>user,:category_id=>category_id,:art_forms=>[art])
end

class OldDb < ActiveRecord::Base  
  establish_connection(YAML.load_file(File.join(Rails.root, "config", "old_database.yml"))['default'])
  def self.exec sql
    connection.select_all sql
  end
end

