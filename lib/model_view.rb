module ModelView

  def field(field_name, arg={}, &block)
    scope_name = @current_scope || :__root__
    add_field scope_name, field_name, arg, block
  end

  def scope(scope_name, &block)
    sym_scope_name = scope_name.to_sym
    add_scope(sym_scope_name)

    @current_scope = sym_scope_name
    instance_eval &block
    @current_scope = nil
  end

  def include_scope(scope)
    raise Exception.new("Root scope can not include another scope") if @current_scope.nil? || @current_scope == :__root__
    @scopes[@current_scope][:includes] << scope
  end

  def extend_scope(scope)
    raise Exception.new("Root scope can not extend another scope") if @current_scope.nil? || @current_scope == :__root__
    @scopes[@current_scope][:extends] << scope
  end

  def scopes
    @scopes
  end

  private

  def add_scope(scope_name)
    @scopes ||= {}
    @scopes[scope_name] = {fields: {}, extends: [], includes: []}
  end

  def add_field(scope, field_name, args, block)
    @scopes ||= {}
    @scopes[scope] ||= {fields: {}, extends: [], includes: []}
    @scopes[scope][:fields][field_name] = {args: args, block: block}
  end
end
