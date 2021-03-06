class ProjectDatatable < AjaxDatatablesRails::Base

  def_delegators :@view, :link_to, :h, :mailto, :edit_project_path, :get_project_ids


  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
      id:         { source: "Project.id",cond: :like,searchable: true, orderable: true},
      artform:     { source: "ArtForm.name",cond: :like ,searchable: true, orderable: true},
      folio:      { source: "fol",  cond: folio_cond ,searchable: true, orderable: true},
      user:       { source: "User.first_name",  cond: :like,searchable: true},
      category:   { source: "Category.name" ,   cond: :like,searchable: true},
      name:       { source: "Information.name" ,   cond: :like,searchable: true},
      #show:       { source: "Project.category.name" },
      #edit:       { source: "Project.status"},
    }


  end

  def data
    records.map do |record|
      {
          id:   record.project_id,
        folio:  record[:fol],
        user:   record.user.first_name,
        category: record.category.name,
          name: Information.find_by_project_id(record.project_id).name,
        show:  link_to( 'Mostrar', Project.find(record.project_id), :class=>'waves-effect waves-light btn',:style=>'color:white'),
        status:  document_validation(record.id)
        #edit: link_to("Editar", @view.edit_project_path(record)),
        # example:
        # id: record.id,
        # name: record.name
      }
    end
  end


  def document_validation(id)
    unless Project.where(id: id).first.blank?
      @valid=Project.where(id: id).first.is_valid?
      @invalid = Project.where(id: id).first.invalid_revisions.pluck(:field,:observations)
      validation = @invalid.empty? ? "Pendiente":"Invalido"
      @valid ? "Valido": validation
    end
  end


  SEPARATOR = Arel::Nodes.build_quoted('-') # inside def throw error
  def folio_cond
    ->(column) do
      fol = Arel::Nodes::NamedFunction.new(
          'concat',
      [::Arel::Nodes::SqlLiteral.new("categories.key"),SEPARATOR,::Arel::Nodes::SqlLiteral.new("art_forms.name"),SEPARATOR,::Arel::Nodes::SqlLiteral.new("projects.id")]
      )
      fol.matches "%#{column}%"           # match change to matches and add the % % flags
    end
  end

  private

  def get_raw_records
    # insert query here
    #Project.references(:user).all

    #Project.includes(:user, :category,:art_form).all.references(:user, :category)
    Project.select('* , concat(categories.key,"-",art_forms.name,"-",projects.id) as fol').joins(:user, :category, :art_forms,:information).where(id: get_project_ids)

  end

  # ==== These methods represent the basic operations to perform on records
  # and feel free to override them

  # def filter_records(records)
  # end

  # def sort_records(records)
  # end

  # def paginate_records(records)
  # end

  # ==== Insert 'presenter'-like methods below if necessary
end
