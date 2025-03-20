namespace :cleanup do
  desc "Supprime tous les emprunts qui n'ont pas de date de début ou de fin"
  task remove_invalid_borrowings: :environment do
    invalid_borrowings = Borrowing.where(start_date: nil).or(Borrowing.where(end_date: nil))
    count = invalid_borrowings.count

    if count > 0
      puts "Suppression de #{count} emprunts invalides..."
      invalid_borrowings.destroy_all
      puts "✅ Nettoyage terminé : #{count} emprunts ont été supprimés"
    else
      puts "✅ Aucun emprunt invalide trouvé"
    end
  end
end
