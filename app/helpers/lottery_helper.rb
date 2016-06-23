module LotteryHelper

    class TermColumn
        attr_reader :num
        attr_reader :tag
        attr_reader :term
        attr_reader :annunciated_at

        def initialize(term, tag, num, annunciated_at)
            @term = term
            @tag = tag
            @num = num.to_i
            @annunciated_at = annunciated_at
            #d = annunciated_at.split('-').map{|x| x.to_i}
            #@annunciated_at = DateTime.new(d[0],d[1],d[2],0,0,0)
        end

        def inspect
            return {'tag' => @tag, 'num' => @num, 'term' => @term, 'annunciated_at' => @annunciated_at}
        end

        def to_json(*a)
            inspect.to_json(*a)
        end
    end


    class TermRow
        attr_reader :columns
        attr_reader :sp_column

        def initialize(r)
            @columns = [
                TermColumn.new(r['term'], 'no1', r['no1'], r['annouced']),
                TermColumn.new(r['term'], 'no2', r['no2'], r['annouced']),
                TermColumn.new(r['term'], 'no3', r['no3'], r['annouced']),
                TermColumn.new(r['term'], 'no4', r['no4'], r['annouced']),
                TermColumn.new(r['term'], 'no5', r['no5'], r['annouced']),
                TermColumn.new(r['term'], 'no6', r['no6'], r['annouced'])
            ]

            @sp_column = TermColumn.new(r['term'], 'spc', r['special'], r['annouced'])
        end

        def term
            @sp_column.term
        end

        def annunciated_at
            @sp_column.annunciated_at
        end

        def all_to_array
            rc = Array.new
            @columns.each {|c| rc << c}
            rc << sp_column
            return rc
        end

        def to_s
            rc = Array.new
            rc << term
            rc.concat( columns.map{|x| x.num} )
            rc << sp_column.num
            rc << annunciated_at
            return rc.join(',')
        end
    end


    class TermNode
        def initialize(num, max)
            @children = nil
            @columns = Array.new
            @max = max
            @num = num.to_s
        end

        def num
            @num
        end

        def record_column(col)
            @columns << col
        end

        def add_childern(arr)
            col = arr.shift
            if col.nil?
                return
            end

            if @children.nil?
                @children = Array.new(@max)
            end

            if @children[col.num].nil?
                @children[col.num] = TermNode.new(col.num, @max)
            end
            @children[col.num].record_column(col)
            @children[col.num].add_childern(arr)
        end


        def build_tree(indent='',last=nil)
            buff = indent

            unless last.nil?
                if last
                    buff += "└-"
                    indent += "  "
                else
                    buff += "├-"
                    indent += "│ "
                end
            end

            term = ''
            unless @columns.empty?
                term += ' size=' + @columns.size.to_s + ' ('
                @columns.each{|col| term += col.term+',' }
                term[-1] = ')'
            end

            buff += @num +term+ "\n"

            if @children.nil?
                return buff
            end

            last_not_null = @children.rindex { |x| x != nil }
            @children.each_with_index do |node,i|
                next if node.nil?
                buff += node.build_tree(indent, last_not_null==i )
            end
            return buff
        end

    end


end
