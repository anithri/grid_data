module GridData
  module SqlOperations
    extend self

    def clause(*args)
      if args.length == 1 && args[0].is_a?(Hash)
        op, field, data = args[0]["op"], args[0]["field"], args[0]["data"]
      else
        op, field, data = *args
      end
      raise GridData::SearchError, "do not understand op: #{op}" unless @@ops_table.has_key?(op)
      [
        @@ops_table[op][:field_proc].call(field),
        @@ops_table[op][:data_proc]. call(data)
      ]
    end

    return_self = lambda{|data| data }
    wild_around = lambda{|data| "%#{data}%"}
    wild_before = lambda{|data| "%#{data}"}
    wild_after = lambda{|data| "#{data}%"}
    sql_like = lambda{|field| "#{field} LIKE ?"}
    sql_not_like = lambda {|field| "#{field} NOT LIKE ?"}
    @@ops_table = {
        "eq" => {
                  :name => "equal",
            :field_proc => lambda{|field| "#{field} = ?"},
             :data_proc => return_self
        },
        "ne" => {
                  :name => "not equal",
            :field_proc => lambda{|field| "#{field} != ?"},
             :data_proc => return_self
        },
        "lt" => {
                  :name => "less",
            :field_proc => lambda{|field| "#{field} < ?"},
             :data_proc => return_self
        },
        "le" => {
                  :name => "less or equal",
            :field_proc => lambda{|field| "#{field} <= ?"},
             :data_proc => return_self
        },
        "gt" => {
                  :name => "greater",
            :field_proc => lambda{|field| "#{field} > ?"},
             :data_proc => return_self
        },
        "ge" => {
                  :name => "greater or equal",
            :field_proc => lambda{|field| "#{field} >= ?"},
             :data_proc => return_self
        },
        "bw" => {
                  :name => "begins with",
            :field_proc => sql_like,
             :data_proc => wild_after
        },
        "bn" => {
                  :name => "does not begin with",
            :field_proc => sql_not_like,
             :data_proc => wild_after
        },
        "in" => {
                  :name => "is in",
            :field_proc => lambda{|field| "#{field} = ?"},
             :data_proc => lambda{|data| "#{data}" }
        },
        "ni" => {
                  :name => "is not in",
            :field_proc => lambda{|field| "#{field} = ?"},
             :data_proc => lambda{|data| "#{data}" }
        },
        "ew" => {
                  :name => "ends with",
            :field_proc => sql_like,
             :data_proc => wild_before
        },
        "en" => {
                  :name => "does not end with",
            :field_proc => sql_not_like,
             :data_proc => wild_before
        },
        "cn" => {
                  :name => "contains",
            :field_proc => sql_like,
             :data_proc => wild_around
        },
        "nc" => {
                  :name => "does not contain",
            :field_proc => sql_not_like,
             :data_proc => wild_around
        }
    }
  end
end
