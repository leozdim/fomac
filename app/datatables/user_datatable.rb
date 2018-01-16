class UserDatatable < AjaxDatatablesRails::Base

  def_delegators :@view, :link_to, :h, :mailto, :edit_user_path, :getUsers


  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
      first_name: { source: "User.first_name", cond: :like, searchable: true, orderable: true },
      last_name:  { source: "User.last_name",  cond: :like, searchable: true},
      second_last_name: { source: "User.second_last_name",  cond: :like ,searchable: true},
      role:        { source: "User.role",searchable: true },
    }
  end

  def data
    records.map do |record|
      {
          first_name:  record.first_name,
          last_name:   record.last_name,
          second_last_name: record.second_last_name,
          role: record.role,
          show: link_to('Show', record ),
          edit: link_to('Edit', @view.edit_user_path(record)),
        # example:
        # id: record.id,
        # name: record.name
      }
    end
  end

  private

  def get_raw_records
    @view.getUsers
    # insert query here
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
