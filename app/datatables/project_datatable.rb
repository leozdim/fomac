class ProjectDatatable < AjaxDatatablesRails::Base

  def_delegators :@view, :link_to, :h, :mailto, :edit_project_path


  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
      folio:      { source: "Project.folio",    cond: :like,searchable: true, orderable: true },
      user:       { source: "User.first_name",  cond: :like,searchable: true},
      category:   { source: "Category.name" ,   cond: :like,searchable: true},
      #show:       { source: "Project.category.name" },
      #edit:       { source: "Project.status"},
    }
  end

  def data
    records.map do |record|
      {
        folio:  record.folio,
        user:   record.user.first_name,
        category: record.category.name,
        show: link_to( 'Mostrar', record),
        edit: link_to("Editar", @view.edit_project_path(record)),
        # example:
        # id: record.id,
        # name: record.name
      }
    end
  end

  private

  def get_raw_records
    # insert query here
    #Project.references(:user).all
    Project.includes(:user, :category).all.references(:user, :category)

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
