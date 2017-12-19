class ProjectDatatable < AjaxDatatablesRails::Base

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
      folio:      { source: "Project.folio", cond: :like, searchable: true, orderable: true },
      name:       { source: "Project.user",  cond: :like },
      category:   { source: "Project.category" },
      status:     { source: "Project.status"},
    }
  end

  def data
    records.map do |record|
      {
          folio:  record.folio,
          name:   record.user,
          category: record.category,
          status: record.status
      }
    end
  end

  private

  def get_raw_records
    # insert query here
    Project.all
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
