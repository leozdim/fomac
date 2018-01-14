namespace :import do
  desc "Migrate the old dba"
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
          participants=q.exec "select * from project_participants where project_id=#{op['project_id'].to_i}"
          participants.each do |p|
            person=create_person project, p
            ppdo=q.exec "select * from project_participants_documents where 
                    project_id=#{op['project_id'].to_i} and participant_id=#{p['participant_id']} "
            ppdo.each{|p| create_person_documents  person, p}
            p_info=q.exec "select * from project_information where project_id=#{op['project_id'].to_i}"
            create_project_information project, p_info.first
            p_retr=q.exec "select * from project_retribution where project_id=#{op['project_id'].to_i}"
            create_retribution project,p_retr.first
            ev=q.exec "select * from evidencia_artes_visuales where project_id=#{op['project_id'].to_i}"
            create_visuals project, ev.first
          end
        end
      end
    end
  end
end

def create_visuals p,ev
  return if ev.nil?
  path="/home/damian/fomac/data/test/artes_visuales_#{ev['project_id']}/"
  e=VisualEvidence.new :project=>p, :image=>multi_reader(path+'img'), :catalog=>multi_reader(path+'catalogo'), 
    :note=>multi_reader(path+'notes'), :document=>multi_reader(path+'docs')
  e.save! validate: false
end

def multi_reader path
  res=[]
  Dir.glob path+'/*' do |doc_path|
    res.push opener doc_path
  end
  res
end

def create_retribution project, r 
  case r['modalidad']
  when 'Artistica'
    m_id=1
  when 'Difusion'
    m_id=3
  when 'Formativa'
    m_id=2
  end
  case r['actividad_a_realizar']
  when 'Conciertos'
    a_id=2
  when 'Conferencias'
    a_id=6
  when 'Cursos'
    a_id=5
  when 'Lecturas publicas'
    a_id=8
  when 'Mesas redondas'
    a_id=7
  when 'Presentaciones escénicas'
    a_id=1
  when 'Recitales individuales o grupales'
    a_id=3
  when 'Talleres'
    a_id=4
  end
  Retribution.create! :project=>project, :modality_id=>m_id, :art_activity_id=>a_id, :description=>r['descripcion_actividad']
end

def create_project_information project, inf 
  cron=old_p_opener inf
  i=Information.new :project=>project,:name=>inf['nombre'],:description=>inf['descripcion'],
      :antecedent=>inf['antecedentes'],:justification=>inf['justificacion'],:general_objective=>inf['objetivo_general'],
      :specific_objective=>inf['objetivos_especificos'],:goals=>inf['metas'],:beneficiary=>inf['beneficiarios'],
      :context=>inf['contexto'],:bibliography=>inf['bibliografia'],
      :activities=>cron,:spending=>cron,:funding=>cron
  i.save! validate: false
end

def create_person_documents person, op
  pd=PersonDocument.new :person=>person,:request_letter=>old_doc_opener(op,'carta_solicitud'),
    :birth=>old_doc_opener(op,'acta_de_nacimiento'),:address=>old_doc_opener(op,'comprobante_de_domicilio'),
    :identification=>old_doc_opener(op,'identificacion_oficial'),:curp=>old_doc_opener(op,'CURP'),
    :resume=>old_doc_opener(op,'curriculum'),:kardex=>old_doc_opener(op,'boleta_kardex'),
    :agreement_letter=>old_doc_opener(op,'carta_compromiso'),:assign_letter=>old_doc_opener(op,'carta_asignacion')
  pd.save!(validate:false)
end

def old_p_opener inf
  path="/home/damian/fomac/data/financiamiento_cronograma/#{inf['project_id']}/#{inf['proyecto_documentos']}"
  opener path 
end

def old_doc_opener  op,name
  path="/home/damian/fomac/data/participantes/#{op['project_id']}_#{op['documents_id']}/#{op[name]}"
  opener path 
end

def opener path
  return File.open path  if File.exists? path  and !File.directory? path
  return nil
end

def create_person project, od
  birthplace='NA'
  birthplace||=od['lugar_de_nacimiento']
  state='NA'
  birthplace||=od['estado']
  city='NA'
  birthplace||=od['ciudad']
  Person.create!(:project=>project, :first_name=>od['nombres'], 
                 :last_name=>od['apellido_paterno'], :second_last_name=>od['apellido_materno'], 
                 :birthdate=>od['fecha_de_nacimiento'].to_date, :home_phone_number=>od['telefono'], :cellphone=>od['celular'], 
                 :birthplace=>birthplace, :state=>state, :city=>city, :nationality=>od['nacionalidad'], 
                 :level_study=>od['grado_de_estudios'] , 
                 :addresses_attributes=>
  [:street=>od['calle'], :internal_number=>od['numero_interior'], :external_number=>od['numero'], :colony=>od['colonia'], :zip=>od['codigo_postal'] ])
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

