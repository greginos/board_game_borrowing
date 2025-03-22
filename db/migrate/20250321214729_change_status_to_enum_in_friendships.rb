class ChangeStatusToEnumInFriendships < ActiveRecord::Migration[8.0]
  def up
    # Supprimer l'index existant sur status
    remove_index :friendships, :status

    # Créer une nouvelle colonne status_enum
    add_column :friendships, :status_enum, :integer, default: 0

    # Convertir les valeurs existantes
    execute <<-SQL
      UPDATE friendships
      SET status_enum = CASE status
        WHEN 'pending' THEN 0
        WHEN 'accepted' THEN 1
        WHEN 'rejected' THEN 2
      END
    SQL

    # Supprimer l'ancienne colonne status
    remove_column :friendships, :status

    # Renommer la nouvelle colonne
    rename_column :friendships, :status_enum, :status

    # Ajouter un index sur la nouvelle colonne
    add_index :friendships, :status
  end

  def down
    # Supprimer l'index sur status
    remove_index :friendships, :status

    # Créer une nouvelle colonne status_string
    add_column :friendships, :status_string, :string

    # Convertir les valeurs existantes
    execute <<-SQL
      UPDATE friendships
      SET status_string = CASE status
        WHEN 0 THEN 'pending'
        WHEN 1 THEN 'accepted'
        WHEN 2 THEN 'rejected'
      END
    SQL

    # Supprimer l'ancienne colonne status
    remove_column :friendships, :status

    # Renommer la nouvelle colonne
    rename_column :friendships, :status_string, :status

    # Ajouter un index sur la nouvelle colonne
    add_index :friendships, :status
  end
end
